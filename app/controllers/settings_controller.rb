class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_endpoint!
  before_action :set_setting, only: [:show, :edit, :update, :destroy]

  # GET /settings
  def index
    settings = current_user.endpoint.actualized_settings
    # TODO: Check for reload and optimize query
    if params[:updates] == '1'
      @pagy, @settings = pagy(settings.updated)
    else
      @pagy, @settings = pagy(settings.all)
    end
  end

  # GET /settings/1
  def show
  end

  # GET /settings/new
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings
  def create
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
      if @setting.destroy
        format.html { redirect_to settings_url, notice: 'Package was successfully removed.' }
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
    @setting = current_user.endpoint.settings.find_by!(package_id: setting_params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def setting_params
    params.permit(:id, :updates)
  end

end
