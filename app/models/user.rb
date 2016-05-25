# A user of the application
class User < ActiveRecord::Base
  validates :cas_directory_id, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end
