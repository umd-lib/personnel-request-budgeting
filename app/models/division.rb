# An organizational division within the library
class Division < ActiveRecord::Base
  has_many :departments
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end
