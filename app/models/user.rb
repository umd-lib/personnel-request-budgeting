# A user of the application
class User < ActiveRecord::Base
  validates :cas_directory_id, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  def admin?
    false
  end

  def divisions
    #['4']
    []
  end

  def departments
    ['10']
    #[]
  end

  def units
    ['6']
    #[]
  end
end
