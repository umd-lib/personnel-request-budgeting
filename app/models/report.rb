# A basic generic report to be run
class Report < ActiveRecord::Base
  belongs_to :user
  alias_attribute :creator, :user

  enum status: %i( pending running error completed )
  enum format: %i( xlsx pdf )

  %i( format status name ).each { |f| validates f, presence: true }

  # sugary method to get the report manager
  def manager
    Manager
  end

  def self.policy_class
    ReportPolicy
  end

  # registers the available reports
  class Manager
    class << self
      attr_accessor :reports

      # Add the report to our list of registered reports...
      def register_report(klass)
        @reports ||= []
        @reports.unshift(klass) # last in, first up
      end

      # really just a sanity check for Rails autoloading
      def load_reports!
        Dir[Rails.root.join('app', 'models', 'reports', '*_report.rb')].each { |f| require_dependency f }
      end

      def reports
        load_reports! if @reports.blank?
        @reports.map { |r| [r.to_s.underscore.titleize, r.to_s.underscore] }
      end

      # we go through our registered reports and see if we can get and
      # instance.. to get and instance of TheCoolReport you pass the_cool_report
      def report_for(report, *args)
        load_reports! if @reports.blank?
        @reports.each do |klass|
          return klass.new(*args) if report == klass.to_s.underscore
        end
      end
    end
  end
end
