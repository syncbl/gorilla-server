class PackagesController < ApplicationController
  include PackagesHelper

  before_action :authenticate_user!, except: %i[show search]
  before_action :forbid_for_endpoint!, only: %i[create update destroy]
  before_action :set_package, except: %i[index new create search]
  skip_authorization_check only: :search
  authorize_resource except: :search

  # TODO: Check every method for includes because there is a lot of N+1

  # GET /packages
  # GET /packages.json
  def index
    @edit = params[:edit] == 1
    @pagy, @packages =
      pagy_countless(Package.accessible_by(current_ability).includes(:sources), items: params[:items])
  end

  # GET /packages/1
  # GET /packages/1.json
  def show; end

  # GET /packages/new
  def new
    @package = Package.new
  end

  # GET /packages/1/edit
  def edit; end

  # POST /packages
  # POST /packages.json
  def create
    @package = current_user.packages.new(package_params_require)
    respond_to do |format|
      if @package.save
        format.html do
          redirect_to package_url(@package), notice: "Package was successfully created."
        end
        format.json { render :show, status: :created, location: @package }
      else
        format.html { render :new }
        format.json do
          render json: @package.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /packages/1
  # PATCH/PUT /packages/1.json
  def update
    respond_to do |format|
      if @package.update(package_params)
        format.html do
          redirect_to package_url(@package), notice: "Package was successfully updated."
        end
        format.json { render :show, status: :ok, location: @package }
      else
        format.html { render :edit }
        format.json do
          render_json_error @package.errors.full_messages,
                            status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /packages/1
  # DELETE /packages/1.json
  def destroy
    respond_to do |format|
      if @package.destroy
        format.html do
          redirect_to packages_url,
                      notice: "Package was successfully destroyed."
        end
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json do
          render_json_error @package.errors.full_messages,
                            status: :unprocessable_entity
        end
      end
    end
  end

  # TODO: Change search logic.
  # - Subscibe to friends and search only there?
  # - Set user before search or search in current_user? <-

  # GET /packages/search
  def search
    if params[:q].present? && params[:q].size >= MIN_NAME_LENGTH
      @pagy, @packages =
        pagy(
          Package.searcheable_by(current_user).search_by_text(params[:q]),
          items: params[:items],
        )
      render :index
    else
      render_json_error I18n.t("errors.messages.search_query_error"),
                        status: :not_found
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  def set_package
    @package = find_package_by_params
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # <input type="text" name="client[name]" value="Acme" />
  def package_params
    params.require(:package).permit(
      :user_id, :name, :version, :type, :caption,
      :short_description, :description,
      # External
      :external_url,
      # Internal
      :path, :root
    )
  end

  def package_params_require
    params.require(:package).require(:type)
    package_params
  end
end
