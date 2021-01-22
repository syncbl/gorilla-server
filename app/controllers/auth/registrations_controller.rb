class Auth::RegistrationsController < Devise::RegistrationsController
  def create
    respond_to do |format|
      format.any(*navigational_formats) { super }
      format.json do
        @user = User.new(registration_params)
        @user.locale = http_accept_language.compatible_language_from(I18n.available_locales)
        @user.generate_username if @user.username.blank?
        if @user.save
          sign_in @user
          render json: session_json(current_user)
        else
          puts @user.errors.messages.to_s
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
        :endpoint
      )
  end
end
