class Role < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :user_id, uniqueness: { scope: :organization_id }

  delegate :cutoff?, to: :organization

  default_scope -> { includes(organization: [:organization_cutoff]) }
end
