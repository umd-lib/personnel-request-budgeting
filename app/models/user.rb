class User < ApplicationRecord
  validates :cas_directory_id, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  has_many :roles
  validates_associated :roles
  accepts_nested_attributes_for :roles, reject_if: :all_blank, allow_destroy: true
  default_scope(lambda do
    includes(roles: { organization: { organization_cutoff: [], children: { children: [:children] } } })
  end)

  def description
    "#{name} (#{cas_directory_id})"
  end

  # A mapper to get the organizational tree
  def organization_mapper(only_active = false)
    lambda do |role|
      return [] if role.cutoff? && only_active
      children = [role.organization]
      child_mapper = lambda do |child|
        children << child
        child.children.each(&child_mapper) unless child.children.empty?
      end
      role.organization.children.each(&child_mapper)
      return children
    end
  end

  # Gets active organizations ( only those not cutoff ) 
  def active_organizations
    admin? ? Organization.all : all_organizations(true)
  end

  # Gets all organizations ( regardless if they're cutoff
  def all_organizations(only_active = false)
    mapper = organization_mapper(only_active)
    roles.map(&mapper).flatten
  end

end
