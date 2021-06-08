class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :check_permissions!, only: %i[update destroy]

  # GET /users/1
  def show; end

  # GET /users/1/edit
  def edit; end

  # PATCH/PUT /users/1
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html do
          redirect_to @user, notice: "User was successfully updated."
        end
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json do
          render_json_error @user.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = params[:id].nil? ? current_user : User.find_by!(name: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.fetch(:user, {})
  end

  def check_permissions!
    @user == current_user
  end
end
