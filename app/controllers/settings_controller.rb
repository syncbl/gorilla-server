class SettingsController < ApplicationController
  include SettingsHelper

  # TODO: Implement this changes in client
  # GET index - list of installed to sync
  # GET show - Show particular setting
  # POST create - install package
  # PUT with body - edit settings
  # POST /sync - sync all installed, delete uninstalled
  # Save all the .sync files in the same folder
  # Every method works ONLY with collection arrays

  # Settings can be used by user only within packages/endpoints
  before_action :authenticate_endpoint!
  before_action :set_setting, only: %i[show]
  before_action :set_endpoint
  skip_authorization_check only: :index

  # GET /endpoints/1/settings
  def index
    @settings = @endpoint.settings
  end

  # TODO: Show with descendants
  # GET /endpoints/1/settings/1
  def show; end

  # @settings = ActualizedSettingsService.call(@endpoint, sources)

  # TODO: /log /data and everything else, because PUT is not good for subelements
  # POST /endpoints/1/settings
  # packages: [<package_id>, ...]
  def create
    @settings = @endpoint.install packages_from_params

    respond_to do |format|
      if @settings.any?
        format.html do
          redirect_to [@endpoint],
                      notice: "Packages soon will be installed."
        end
        format.json do
          render :sync, status: :accepted
        end
      else
        format.html { render :new }
        format.json do
          render_json_error "TODO:", status: :unprocessable_entity
        end
      end
    end
  end

  # POST /endpoints/1/settings/sync
  # settings: [{ id: <package_id>, ... }, ...]
  def sync
    setting_params[:settings].each do |setting|
      # TODO: Update setting, prepare array of results
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
    @setting = @endpoint.settings.find_by(package_id: params[:id])
    authorize! :show, @setting
  end

  # TODO: Allow to choose endpoint of current user
  def set_endpoint
    @endpoint = authorize! :show, current_endpoint
  end

  # Only allow a trusted parameter "white list" through.
  def setting_params
    params.permit(settings: [:id])
    params.require(:settings)
  end

  def package_params
    params.require(:packages)
  end
end
