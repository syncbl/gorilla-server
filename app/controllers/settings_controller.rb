class SettingsController < ApplicationController
  include PackagesHelper

  # Settings can be used by user only within packages/endpoints
  before_action :authenticate_endpoint!
  before_action :set_setting, except: %i[index create create_all]
  before_action :set_package, only: :create
  before_action :set_endpoint
  skip_authorization_check only: :index

  # TODO: To Post
  # GET /endpoints/1/settings
  def index
    sources = if params[:sources]
        params[:sources].split(",")
                        .grep(UUID_FORMAT)
      else
        []
      end
    @settings = ActualizedSettingsService.call(@endpoint, sources)
  end

  # GET /endpoints/1/settings/1
  def show
    authorize! :show, @setting
  end

  # POST /endpoints/1/settings
  def create
    authorize! :show, @package
    @setting = PackageInstallService.call(@endpoint, [@package]).first
    respond_to do |format|
      if @setting.persisted?
        format.html do
          redirect_to [@endpoint, @setting],
                      notice: "Package soon will be installed."
        end
        format.json do
          render :show, status: :accepted, location: [@endpoint, @setting]
        end
      else
        format.html { render :edit }
        format.json do
          render json: @setting.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # POST /endpoints/1/settings/bulk
  def create_all
    packages = if params[:packages]
      params[:packages].split(",").grep(UUID_FORMAT).map do |package|
        authorize! :show, Package.find_by(id: package)
      end
    else
      []
    end

    @settings = PackageInstallService.call(@endpoint, packages)
    respond_to do |format|
      format.html do
        redirect_to [@endpoint],
                    notice: "Packages soon will be installed."
      end
      format.json do
        render :index, status: :accepted
      end
    end
  end

  # PATCH/PUT /endpoints/1/settings/1
  def update
    respond_to do |_format|
      if @setting.update(setting_params)
        redirect_to [@endpoint, @setting],
                    notice: "Setting was successfully updated."
      else
        render_json_error @setting.errors.full_messages,
                          status: :unprocessable_entity
      end
    end
  end

  # DELETE /endpoints/1/settings/1
  # No need in permission check here: endpoint is already authorized
  def destroy
    respond_to do |format|
      setting = @endpoint.settings.find_by(package_id: params[:package_id])
      if setting.destroy
        format.html do
          redirect_to settings_url, notice: "Package was successfully removed."
        end
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json do
          render_json_error @endpoint.errors.full_messages,
                            status: :unprocessable_entity
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_setting
    @setting = @endpoint.settings.find_by!(package_id: params[:id])
  end

  # TODO: Allow to choose endpoint of current user
  def set_endpoint
    @endpoint = authorize! :show, current_endpoint
  end

  # Only allow a trusted parameter "white list" through.
  def setting_params
    params.require(:setting).permit(:id)
  end

  def set_package
    @package = find_package_by_params
  end
end
