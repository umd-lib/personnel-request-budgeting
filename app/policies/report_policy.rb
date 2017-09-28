# Policy for making and viewing reports
class ReportPolicy < AdminOnlyPolicy
  def edit?
    false
  end
end
