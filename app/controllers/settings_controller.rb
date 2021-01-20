class SettingsController < ApplicationController
  # Settings can be used by user only within packages/endpoints
  before_action :require_endpoint! # TODO: replace with only set_endpoint
  before_action :set_endpoint
  before_action :set_setting, except: %i[index new create]

  # GET /settings
  def index
    current_endpoint.settings.actualize!
    settings = current_endpoint.settings

    # TODO: !!! Check for reload and optimize query
    if params[:updates] == '1'
      @pagy, @settings = pagy(settings.updated)
    else
      @pagy, @settings = pagy(settings.all)
    end
  end

  # GET /settings/1
  def show; end

  # GET /settings/new
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit; end

  # POST /settings
  def create
    respond_to do |format|
      if @setting = @endpoint.settings.create(
        package: Package.allowed_for(current_user).find_by_alias(params[:package_id])
      )
        format.html { redirect_to settings_url, notice: 'Package soon will be installed.' }
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
      redirect_to @setting, notice: 'Setting was successfully updated.'
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
          redirect_to settings_url, notice: 'Package was successfully removed.'
        end
        format.json { head :no_content }
      else
        format.html { render :show }
        format.json { head :unprocessable_entity }
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
