# A role describing access permissions
class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :role_type, counter_cache: true

  belongs_to :division
  belongs_to :department
  belongs_to :unit

  validates :user, presence: true
  validates :role_type, presence: true

  validate :single_org_unit_specified_when_not_admin
  validate :org_unit_specified_when_not_admin
  validate :not_duplicate

  def self.policy_class
    AdminOnlyPolicy
  end

  # Verifies that only a single organizational unit is selected.
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def single_org_unit_specified_when_not_admin
    return if role_type.nil?
    role_type_code = role_type.code
    if (division && role_type_code != 'division') ||
       (department && role_type_code != 'department') ||
       (unit && role_type_code != 'unit')
      errors.add(:base, 'Only one organizational unit should be selected')
    end
  end

  # Verifies that division, department or unit is filled in, based on
  # selected role type.
  # rubocop:disable Metrics/AbcSize
  def org_unit_specified_when_not_admin
    return if role_type.nil?
    role_type_code = role_type.code
    errors.add(:division, 'must not be empty') if role_type_code == 'division' && division.nil?
    errors.add(:department, 'must not be empty') if role_type_code == 'department' && department.nil?
    errors.add(:unit, 'must not be empty') if role_type_code == 'unit' && unit.nil?
  end

  # Verifies that this is not a duplicate record.
  # rubocop:disable Metrics/MethodLength
  def not_duplicate
    return if user.nil? || role_type.nil?

    # Find all records with the same user and role type
    existing = Role.where('user_id = ? and role_type_id = ?', user, role_type)
    # Remove the current record, if it is in the result set.
    existing = existing.where.not('id = ?', id) unless id.nil?
    return if existing.empty?

    role_type_code = role_type.code
    if role_type_code == 'admin' ||
       (role_type_code == 'division' && division && existing.where('division_id = ?', division).any?) ||
       (role_type_code == 'department' && department && existing.where('department_id = ?', department).any?) ||
       (role_type_code == 'unit' && unit && existing.where('unit_id = ?', unit).any?)
      errors.add(:base, 'Role already exists')
    end
  end

  # @return [String] a short human-readable description for this record, for
  #   GUI prompts
  def description
    name = user.name
    type = role_type.name

    return "#{name}, #{type}" if role_type.code == 'admin'
    org = division.name if role_type.code == 'division' && division
    org = department.name if role_type.code == 'department' && department
    org = unit.name if role_type.code == 'unit' && unit

    "#{name}, #{type}, #{org}"
  end
end
