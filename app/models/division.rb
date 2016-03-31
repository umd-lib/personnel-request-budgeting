# An organizational division within the library
class Division < ActiveRecord::Base
  has_many :departments
  validates :code, presence: true
  validates :name, presence: true
end
