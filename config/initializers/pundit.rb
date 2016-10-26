require 'pundit'

module Pundit
  class NotAuthorizedDepartmentError < NotAuthorizedError; end
  class NotAuthorizedUnitError < NotAuthorizedError; end
end
