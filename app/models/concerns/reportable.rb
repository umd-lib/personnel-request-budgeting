## Generic for all request type objects
## including this in your report adds common functionality and registers it in
# the reportmanager
module Reportable
  extend ActiveSupport::Concern

  class << self
    def included(report)
      report.extend ClassMethods
      Report::Manager.register_report(report)
    end
  end

  # These are class methods that are extended
  module ClassMethods
    # Any parameters you will need to pass to your query
    def allowed_parameters
      %i( )
    end

    # The formats your report responds to
    def formats
      %w( xlsx )
    end

    # Some brief test to describe what the report does
    def description
      'Text to be overridden in the Reportable subclass'
    end
  end

  attr_accessor :parameters

  # when we make a Reportable obj, we pass the parameters serialized in the
  # master Report instance
  def initialize(parameters = nil)
    @parameters = parameters
  end

  # Override this method to define your query
  def query; end

  # alias to .formats
  def formats
    self.class.formats
  end

  # alias to .description
  def description
    self.class.description
  end
end
