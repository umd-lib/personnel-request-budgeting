require_relative 'organization'

class User < ApplicationRecord
  validates :cas_directory_id, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  has_many :roles, dependent: :delete_all
  validates_associated :roles
  accepts_nested_attributes_for :roles, reject_if: :all_blank, allow_destroy: true

  has_many :organizations, through: :roles

  default_scope(lambda do
    includes(roles: { organization: { organization_cutoff: [], children: { children: [:children] } } })
  end)

  def description
    "#{name} (#{cas_directory_id})"
  end

  # A mapper to get the organizational tree
  def organization_mapper(only_active = true)
    lambda do |org|
      return [] if org.cutoff? && only_active
      active_children = [org]
      child_mapper = lambda do |child|
        active_children << child
        child.children.each(&child_mapper) unless child.children.empty?
      end
      org.children.each(&child_mapper)
      return active_children
    end
  end

  # Gets active organizations ( only those not cutoff )
  def active_organizations
    admin? ? Organization.all : organizations.map(&organization_mapper).flatten
  end

  # Gets all organizations ( regardless if they're cutoff ) down the
  # ancestorial tree..
  def all_organizations
    admin? ? Organization.all : organizations.map(&organization_mapper(false)).flatten
  end

  # this returns if the user has a role related to a specific org type
  # for example we define unit? to find any active roles with a org that
  # has org type == 'unit'
  Organization.organization_types.keys.each do |type|
    define_method "#{type}?" do
      organizations.any? { |org| org.organization_type == type }
    end
  end
end
