# A subdepartment within a department
class Subdepartment < ActiveRecord::Base
  belongs_to :department
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :department_id, presence: true
end
