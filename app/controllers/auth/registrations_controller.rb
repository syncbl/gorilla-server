class Auth::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def create
    respond_to do |format|
      format.any(*navigational_formats) { super }
      format.json do
        @user = User.new(registration_params)
        if @user.save
          sign_in @user
          authenticate_endpoint(@user, params)
        else
          render_error_json('E_API_REGISTER', ' cant register ', :unauthorized)
        end
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def registration_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end