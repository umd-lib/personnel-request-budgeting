# This abstracts out the report rendering from the ApplicationController
# but allows for the request context to be intact
class ReportGenerator < ActionController::Metal
  include ActionView::ViewPaths
  include AbstractController::Rendering
  include AbstractController::Helpers
  include ActionController::Helpers
  include ActionView::Rendering
  include ActionView::Layouts
  include ActionController::Rendering
  include ActionController::Renderers
  include ActionController::Renderers::All

  include ActionDispatch::Routing::PolymorphicRoutes
  include Rails.application.routes.url_helpers

  default_url_options[:host] = ::Rails.application.routes.default_url_options[:host] || 'https://localhost'
  helper :personnel_requests

  # just a sanity check
  append_view_path 'app/views'

  def self.generate(report)
    new.generate_report(report)
  end

  def generate_report(report)
    klass = report.name.constantize
    record_set = klass.query
    render_to_string(template: 'shared/index', formats: report.format,
                     locals: { klass: klass, record_set: record_set })
  end
end
