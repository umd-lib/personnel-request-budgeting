# Policy for makeing and viewing reports
class ReportPolicy < AdminOnlyPolicy
  def edit?
    false
  end
end
