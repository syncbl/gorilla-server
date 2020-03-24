class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_setting, only: [:show, :edit, :update, :destroy]

  # GET /settings
  def index
    current_user.endpoint.actualize!
    @settings = current_user.endpoint.settings.kept.all
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
    @setting = Setting.new(setting_params)

    if @setting.save
      redirect_to @setting, notice: 'Setting was successfully created.'
    else
      render :new
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
  def destroy
    @setting.destroy
    redirect_to settings_url, notice: 'Setting was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # ActiveRecord::RecordNotFound only with find_by
    def set_setting
      @setting = current_user.endpoint.settings.find_by!(package: Package.find_by('key = ? OR alias = ?', params[:id], params[:id]))
    end

    # Only allow a trusted parameter "white list" through.
    def setting_params
      params.fetch(:setting, {})
    end
end
