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
    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated."
    else
      format.html { render :edit }
    end
  end

  # TODO: Dashboard
  def dashboard
    if user_signed_in?
      #
    else
      #
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = params[:id].nil? ? current_user : User.find_by!(name: params[:id].downcase)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.fetch(:user, {})
  end

  def check_permissions!
    @user == current_user
  end
end
