class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :role_type
  belongs_to :division
  belongs_to :department
  belongs_to :unit
end
