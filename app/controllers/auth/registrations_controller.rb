class Auth::RegistrationsController < Devise::RegistrationsController
  def create
    respond_to do |format|
      format.any(*navigational_formats) { super }
      format.json do
        @user = User.new(registration_params)
        @user.locale = http_accept_language.compatible_language_from(I18n.available_locales)
        if @user.save
          sign_in @user
          current_user.token = JsonWebToken.encode(@user)
          render 'users/show'
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
        :username,
      )
  end
end
