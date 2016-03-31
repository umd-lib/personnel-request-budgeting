# An organizational division within the library
class Division < ActiveRecord::Base
  has_many :departments
  validates :name, presence: true
end
