class SettingsController < ApplicationController
  # Settings can be used by user only within packages/endpoints
  before_action :set_endpoint
  before_action :set_setting, except: %i[index create]

  # GET /settings
  def index
    current_endpoint.settings.actualize!
    settings = current_endpoint.settings

    # TODO: !!! Check for reload and optimize query
    @pagy, @settings = params[:updates].present? ? pagy(settings.updated) :
      @pagy, @settings = pagy(settings.all)
  end

  # GET /settings/1
  def show; end

  # POST /settings
  def create
    respond_to do |format|
      if @setting = @endpoint.settings.create(
        package: Package.allowed_for(@endpoint.user).find_by_alias(params[:package_id]),
      )
        format.html { redirect_to settings_url, notice: "Package soon will be installed." }
        format.json { render :show, status: :accepted, location: @setting }
      else
        format.html { render :edit }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/1
  def update
    # TODO: Use as sync: delete if discarded, set "installed" if not
    if @setting.update(setting_params)
      redirect_to @setting, notice: "Setting was successfully updated."
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
          redirect_to settings_url, notice: "Package was successfully removed."
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
    @setting = @endpoint.settings.find_by!(package_id: setting_params[:id])
  end

  def set_endpoint
    @endpoint = params[:endpoint_id].nil? ?
      current_endpoint : current_user&.endpoints.find(params[:endpoint_id])
  end

  # Only allow a trusted parameter "white list" through.
  def setting_params
    params.permit(:id, :updates)
  end
end
