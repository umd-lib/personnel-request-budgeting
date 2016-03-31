# A department within a library division
class Department < ActiveRecord::Base
  belongs_to :division
end
