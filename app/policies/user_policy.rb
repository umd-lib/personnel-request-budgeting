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

  def impersonate?
    user.admin? && (user.id != record.id)
  end
end
