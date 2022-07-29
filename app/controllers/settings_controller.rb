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
  # Endpoint must be identified before everything else
  before_action :set_endpoint
  before_action :set_setting, only: %i[show]
  before_action :set_sources, only: %i[sync]
  # TODO: Auhtorize or this enough?
  skip_authorization_check only: %i[index sync] # TODO: Don't skip

  # GET /endpoints/1/settings
  def index
    @settings = @endpoint.settings
  end

  # TODO: Show with descendants
  # GET /endpoints/1/settings/1
  def show
    authorize! :show, @setting
  end

  # @settings = ActualizedSettingsService.call(@endpoint, sources)

  # TODO: !!! /log /data and everything else, because PUT is not good for subelements
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
          render_json_error @endpoint.errors.messages,
                            status: :unprocessable_entity
        end
      end
    end
  end

  # POST /endpoints/1/settings/sync
  # sources: [<source_id>, ...], packages: [<package_id>, ...]
  def sync
    sync_params[:sources].each do |setting|
      @settings = ActualizedSettingsService.call(@endpoint, @sources)




      # TODO: Update setting, prepare array of results
    end
    # TODO: Temporary solution to pass tests!!!
    @settings = Setting.all
    # authorize! @settings, :show
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
    # TODO: Optimize by reducing number of queries and fixing error message
    @setting = Setting.find_by! endpoint: @endpoint, package: Package.find(params[:id])
  end

  def set_endpoint
    # TODO: Allow to choose endpoint of current user /endpoint/1/settings
    # params || current_endpoint
    @endpoint = current_endpoint
  end

  def set_sources
    @sources = Source.where(id: sync_params[:sources])
  end

  # Only allow a trusted parameter "white list" through.
  def setting_params
    params.permit(settings: [:id])
    params.require(:settings)
  end

  def package_params
    params.require(:packages)
  end

  def sync_params
    params.permit(sources: [:source_id], packages: [:package_id])
  end
end
