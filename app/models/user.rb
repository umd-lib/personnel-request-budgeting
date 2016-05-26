# A user of the application
class User < ActiveRecord::Base
  has_many :roles, dependent: :restrict_with_exception
  validates :cas_directory_id, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end
