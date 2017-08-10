# Policy that only allows users to see and edit their own User entry
class UserPolicy < AdminOnlyPolicy
  def show?
    user.admin? || (user.id == record.id)
  end

  def edit?
    user.admin? || (user.id == record.id)
  end

  def update?
    user.admin? || (user.id == record.id)
  end

  # Users can impersonate if:
  # 1) They are an admin
  # 2) The target is not an admin
  # 3) The are not impersonating themselves
  # 4) The record actually exists
  def impersonate?
    user.admin? && !record.admin? && (user.id != record.id) && record.persisted?
  end
end
