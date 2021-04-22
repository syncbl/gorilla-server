class SettingsController < ApplicationController
  # Settings can be used by user only within packages/endpoints
  before_action :authenticate_user!, only: %i[create]
  before_action :set_endpoint, except: %i[create]
  before_action :set_endpoint_by_id, only: %i[create]
  before_action :set_setting, except: %i[index create]

  # GET /settings
  def index
    settings = ActualizedSettingsQuery.call(@endpoint.settings.includes(:icon_attachment))
    # TODO: !!! Check for reload and optimize query
    @pagy, @settings = params[:updates] ? pagy(settings.updated) :
      pagy(settings.all)
  end

  # GET /settings/1
  def show; end

  # POST /endpoints/1/settings
  def create
    # TODO: Policy authorization
    @package = PublishedPackagesQuery.call(current_user).find_any!(params[:package_id])
    respond_to do |format|
      if @setting = @endpoint.install(@package)
        format.html do
          redirect_to [@endpoint, @setting], notice: "Package soon will be installed."
        end
        format.json { render :show, status: :accepted, location: [@endpoint, @setting] }
      else
        format.html { render :edit }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/1
  def update
    if @setting.update(setting_params)
      redirect_to [@endpoint, @setting], notice: "Setting was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /settings/1
  # No need in permission check here: endpoint is already authorized
  def destroy
    respond_to do |format|
      if @endpoint.settings.find_by(package_id: params[:package_id])&.discard
        format.html do
          redirect_to endpoint_settings_url, notice: "Package was successfully removed."
        end
        format.json { head :no_content }
      else
        format.html { render :show }
        format.json do
          render json: @package.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # ActiveRecord::RecordNotFound only with find_by
  def set_setting
    @setting = @endpoint.settings.find_by!(package_id: params[:id])
  end

  # TODO: Endpoint.install here is only for API, but how to do that for UI?
  def set_endpoint
    head :unauthorized unless @endpoint = current_endpoint
  end

  # TODO: 
  def set_endpoint_by_id
    @endpoint = current_user&.endpoints.find(params[:endpoint_id])
  end

  # Only allow a trusted parameter "white list" through.
  #def setting_params
  #  params.permit(:id, :updates)
  #end
end
