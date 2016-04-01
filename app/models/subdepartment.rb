# A subdepartment within a department
class Subdepartment < ActiveRecord::Base
  belongs_to :department
  validates :code, presence: true
  validates :name, presence: true
  validates :department_id, presence: true
end
