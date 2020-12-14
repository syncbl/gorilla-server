class Auth::RegistrationsController < Devise::RegistrationsController
  def create
    respond_to do |format|
      format.any(*navigational_formats) { super }
      format.json do
        @user = User.new(registration_params)
        if @user.save
          sign_in @user
          generate_token
        else
          render json: @user.errors, status: :unauthorized
        end
      end
    end
  end

  protected

  def registration_params
    params
      .require(:user)
      .permit(
        :email,
        :password,
        :password_confirmation,
        :name,
        :locale,
        :endpoint
      )
  end
end
