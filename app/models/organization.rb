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
  end

  belongs_to :parent, class_name: 'Organization', foreign_key: 'organization_id'
  has_many :children, foreign_key: :organization_id, class_name: 'Organization'
  # a more basic AR way of getting children
  has_many :organizations

  has_one :organization_cutoff, foreign_key: :organization_type, primary_key: :organization_type

  has_many :requests, dependent: :restrict_with_error, counter_cache: true
  has_many :archived_requests, dependent: :restrict_with_exception, counter_cache: true

  has_many :roles
  validates_associated :roles
  accepts_nested_attributes_for :roles, reject_if: :all_blank, allow_destroy: true

  validates :code, :organization_type, :name, presence: true
  validates :code, uniqueness: true

  validate :only_one_root

  def only_one_root
    return if organization_type != 'root'
    org =  Organization.find_by(organization_type: Organization.organization_types[:root])
    return if org.nil? || org.id == id
    errors.add(:organization_type, 'There can be only one root')
  end

  def cutoff?
    return true unless organization_cutoff
    Time.zone.today > organization_cutoff.cutoff_date
  end

  def text
    "#{name} (#{code})"
  end

  def grandchildren
    children.map(&:children).flatten || []
  end

  def great_grandchildren
    grandchildren.map(&:children).flatten || []
  end

  def as_json(options = {})
    org = super
    org[:id] = org['id']
    org[:parent] = org['organization_id'] || '#'
    org[:icon] = 'glyphicon glyphicon-home'
    org[:text] ||= text
    org[:state] = { opened: true }
    org
  end
end
