require_relative 'organization'

class User < ApplicationRecord
  validates :cas_directory_id, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  has_many :roles, dependent: :delete_all
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

  # this returns if the user has a role related to a specific org type
  # for example we define unit? to find any active roles with a org that
  # has org type == 'unit'
  Organization.organization_types.keys.each do |type|
    define_method "#{type}?" do
      active_organizations.any? { |org| org.organization_type == type }
    end
  end
end
