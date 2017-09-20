# The Organization the the request is associated to
class Organization < ApplicationRecord
  include Cutoffable

  class << self
    def policy_class
      AdminOnlyPolicy
    end

    def root_org
      root.first
    end

    def reset_counters(id, *counters)
      object = find(id)
      counters.each do |counter_association|
        has_many_association = _reflect_on_association(counter_association)
        unless has_many_association
          has_many = reflect_on_all_associations(:has_many)
          has_many_association = has_many.find do |association|
            association.counter_cache_column &&
              association.counter_cache_column.to_sym == counter_association.to_sym
          end
          counter_association = has_many_association.plural_name if has_many_association
        end
        raise ArgumentError, "'#{name}' has no association called '#{counter_association}'" unless has_many_association

        if has_many_association.is_a? ActiveRecord::Reflection::ThroughReflection
          has_many_association = has_many_association.through_reflection
        end

        foreign_key  = has_many_association.foreign_key.to_s
        child_class  = has_many_association.klass
        reflection   = child_class._reflections.values.find do |e|
          e.belongs_to? &&
            e.foreign_key.to_s == foreign_key &&
            e.options[:counter_cache].present?
        end
        counter_name = reflection.counter_cache_column

        count = object.send(counter_association).count(:all)
        count += object.send("unit_#{counter_association}").count(:all) if object.organization_type == 'unit'
        stmt = unscoped.where(arel_table[primary_key].eq(object.id))
                       .arel.compile_update({ arel_table[counter_name] => count }, primary_key)
        connection.update stmt
      end
      true
    end
  end

  # this is used to generate the organization's associated icon
  TYPE_MAPPING = { 'root' => 'queen', 'division' => 'bishop', 'department' => 'knight', 'unit' => 'pawn' }.freeze
  # fields that cna't be changed if there are records in teh archive
  UNEDITABLE_IF_ARCHIVED = %w[organization_id name code organization_type].freeze

  belongs_to :parent, class_name: 'Organization', foreign_key: 'organization_id'
  validates :organization_id, presence: true, unless: :root?

  has_many :children, foreign_key: :organization_id, class_name: 'Organization'
  # a more basic AR way of getting children
  has_many :organizations

  has_one :organization_cutoff, foreign_key: :organization_type, primary_key: :organization_type

  has_many :requests, dependent: :restrict_with_error
  has_many :archived_requests, dependent: :restrict_with_error

  has_many :unit_requests, dependent: :restrict_with_error, class_name: 'Request', foreign_key: :unit_id
  has_many :unit_archived_requests, dependent: :restrict_with_error, class_name: 'Request', foreign_key: :unit_id

  has_many :roles, dependent: :delete_all
  validates_associated :roles
  accepts_nested_attributes_for :roles, reject_if: :all_blank, allow_destroy: true
  has_many :users, through: :roles

  validates :code, :organization_type, :name, presence: true

  # apparently code does not have to be unique?
  # validates :code, uniqueness: true

  validate :only_one_root, :no_edits_if_archive

  # this makes sure we only have one root record
  def only_one_root
    return if organization_type != 'root'
    org =  Organization.find_by(organization_type: Organization.organization_types[:root])
    return if org.nil? || org.id == id
    errors.add(:organization_type, 'There can be only one root')
  end

  # this makes an org immutable if in archive. We can only activate/deactivate
  def no_edits_if_archive
    uneditable = changes.keys & UNEDITABLE_IF_ARCHIVED
    return unless persisted?
    return unless archived_records?
    return if uneditable.empty?
    uneditable.each do |k|
      msg = "#{description} has #{archived_requests.count} in the archive. Editing #{k} is not allowed."
      errors.add(k.intern, msg)
    end
  end

  def archived_records?
    if organization_type == 'unit'
      ArchivedRequest.where(unit_id: id).count > 0
    else
      archived_requests_count > 0
    end
  end

  def cutoff?
    return false unless organization_cutoff
    Time.zone.today > organization_cutoff.cutoff_date
  end

  def active?
    !cutoff? && !deactivated?
  end

  # the name of the record used in the json expression
  def text
    icon = if cutoff?
             'ban-circle'
           elsif deactivated?
             'remove-circle'
           else
             'ok-circle'
           end
    "#{name} (#{code}) <i class='glyphicon glyphicon-#{icon}'></i>"
  end

  def grandchildren
    children.map(&:children).flatten || []
  end

  def great_grandchildren
    grandchildren.map(&:children).flatten || []
  end

  # returns an array of the organizations up the tree
  def ancestors
    mom = parent
    ancestors = []
    while mom
      ancestors << mom
      mom = mom.parent
    end
    ancestors
  end

  def description
    "#{name} ( #{organization_type} )"
  end

  def type_icon
    "glyphicon glyphicon-#{TYPE_MAPPING[organization_type]}"
  end

  def as_json(options = {})
    org = super
    org[:id] = org['id']
    org[:parent] = org['organization_id'] || '#'
    org[:icon] = type_icon
    org[:text] ||= text
    org[:state] = { opened: true }
    org
  end
end
