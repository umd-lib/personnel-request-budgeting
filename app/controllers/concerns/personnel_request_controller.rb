module PersonnelRequestController
  extend ActiveSupport::Concern
  include RequestHelper
  include XlsxHelper

  included do
    # after_action :verify_policy_scoped, only: :index
    before_action :set_model_klass, only: %i[index new create]
    before_action :set_request, only: %i[show edit update destroy]

    # this makes all our mixed-in controllers user "requests" for view path
    # And it works with Mini Test!!
    def self.local_prefixes
      [controller_path, 'requests']
    end
    private_class_method :local_prefixes
  end

  def index
    @requests = policy_scope(@model_klass).order(params[:sort])
    respond_to do |format|
      format.html { @requests = @requests.paginate(page: params[:page]) }
      format.xlsx { send_xlsx(@requests, @model_klass) }
    end
  end

  def show
    authorize @request
  end

  def new
    authorize @model_klass
    @request = @model_klass.new
  end

  def edit
    authorize @request
  end

  def update
    authorize @request
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to(@request, notice: "#{@request.description} successfully updated.") }
        format.json { render(json: @request, status: :ok) }
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprossable_entity }
      end
    end
  end

  def create
    authorize @model_klass
    @request = @model_klass.new(request_params)
    respond_to do |format|
      if @request.save
        format.html { redirect_to(@request, notice: "#{@model_klass.human_name} successfully created. ") }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    authorize @request
    if @request.destroy
      flash[:notice] = "#{@model_klass.human_name}  for #{@request.description} was successfully deleted."
    else
      flash[:error] = "ERROR Deleting #{@model_klass.human_name}  #{@request.description} (#{@request.id})"
    end
    respond_to do |format|
      format.html { redirect_to(polymorphic_url(@model_klass)) }
    end
  end

  private

    # sets which model class we're using in the controller context
    # this is only used for index and new actions. Other actions get the klass
    # set when the record is assigned.
    def set_model_klass
      @model_klass = archive? ? archive_model_klass : model_klass
    end

    # This returns the Archived varient of the controller's model_klass
    def archive_model_klass
      "Archived#{model_klass.name}".constantize
    end

    # this searches for a record in both the regular and archived tables
    def active_or_archive
      model_klass.find(params[:id])
    # we could not find the record so we check the archive
    rescue ActiveRecord::RecordNotFound
      # for the purposes of archive was can cast the record as a regular record
      # so the view stays happy
      archive_model_klass.find(params[:id]).to_source_proxy
    end

    def set_request
      @request = active_or_archive
      @model_klass = @request.source_class
    rescue ActiveRecord::RecordNotFound
      render(file: Rails.root.join('public', '404.html'), status: :not_found, layout: false)
    end

    def request_params
      params.require(model_klass.name.underscore.intern).permit(allowed)
    end

    # this is a baseline set of attibutes for requests. For a particular request
    # type, override this method in the related controller.
    def allowed
      policy(@request || @model_klass.new).permitted_attributes
    end

    # Returns a send_data of the XLSX of a record set ( used in the request
    # controllers )
    #
    # record_set: the ransack results in the query
    # filename: the filename sent in the response headers
    def send_xlsx(record_set, klass)
      stream = render_to_string(template: 'requests/index', locals: { klass: klass, record_set: [record_set] })
      send_data(stream, filename: "#{klass.name.underscore}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.xlsx")
    end
end
