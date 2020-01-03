class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :auth]

  # GET /users/1
  def show
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      format.html { render :edit }
    end
  end

  # TODO: Dashboard
  def dashboard
    if current_user
      #
    else
      #
    end
  end

  def auth
    # TODO: Check all
    respond_to do |format|
      format.html { redirect_to @user }
      format.json do
        if (request.headers['X-API-VersionId'] = Rails.application.config.api_version)
          #|| (@endpoint = current_user.endpoints.find_by(key: request.headers['X-User-Endpoint']))
          #|| (params[:service] = Digest::MD5.file('storage/README.md').base64digest)
          # TODO: Add all other auth params
          # TODO: Add all incoming entities, like endpoint and settings data
          @endpoint.touch
          render :show
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(current_user.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.fetch(:user, {})
    end
end
