class SettingsController < ApplicationController
  # Settings can be used by user only within packages/endpoints
  before_action :authenticate_user!, only: %i[create]
  before_action :set_endpoint, except: %i[create]
  before_action :set_endpoint_by_id, only: %i[create]
  before_action :set_setting, except: %i[index create]

  # GET /settings
  def index
    settings = ActualizedSettingsService.call(@endpoint.settings.with_includes)
    @pagy, @settings = params[:updates] ? pagy_countless(settings.updated) :
      pagy_countless(settings.all)
  end

  # GET /settings/1
  def show; end

  # POST /endpoints/1/settings
  def create
    check_view! package = Package.find(params[:package_id])
    respond_to do |format|
      if @setting = @endpoint.install(package)
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

  # TODO: Add source_id updating to show current state
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        redirect_to [@endpoint, @setting], notice: "Setting was successfully updated."
      else
        render_json_error @setting.errors.full_messages, status: :unprocessable_entity
      end
    end
  end

  # DELETE /settings/1
  # No need in permission check here: endpoint is already authorized
  def destroy
    respond_to do |format|
      setting = @endpoint.settings.find_by(package_id: params[:package_id])&.discard
      if setting.discarded?
        format.html do
          redirect_to settings_url, notice: "Package was successfully removed."
        end
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json do
          render_json_error @endpoint.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # ActiveRecord::RecordNotFound only with find_by
  def set_setting
    @setting = @endpoint.settings.with_includes.find_by!(package_id: params[:id])
  end

  def set_endpoint
    head :unauthorized unless @endpoint = current_endpoint
  end

  def set_endpoint_by_id
    @endpoint = current_user&.endpoints.find(params[:endpoint_id])
  end

  # Only allow a trusted parameter "white list" through.
  #def setting_params
  #  params.permit(:id, :updates)
  #end
end
