## Generic for all request type objects
## including this in your report adds common functionality and registers it in
# the reportmanager
module Reportable
  # not sure we need a AS here...
  #  extend ActiveSupport::Concern

  class << self
    def included(report)
      Report::Manager.register_report(report)
    end

    # Set your query for the report
    def query; end
  end

  attr_accessor :parameters

  # alias to .query
  def query
    self.class.query
  end

  def fields
    self.class.fields
  end
end
