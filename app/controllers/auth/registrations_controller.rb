class Auth::RegistrationsController < Devise::RegistrationsController
  after_action :reset_token!, only: :create,
                              if: -> { request.format.json? }

  def create
    respond_to do |format|
      format.any(*navigational_formats) { super }
      format.json do
        @user = User.new(registration_params) do |user|
          user.locale = http_accept_language.compatible_language_from(I18n.available_locales)
          user.reseted_at = Time.current
        end
        # TODO: Check registration error here, fullname?
        if @user.save
          sign_in @user
          render "users/show"
        else
          # puts @user.errors.to_json
          # render json: @user.errors, status: :unauthorized
          render_json_error @user.errors.full_messages, status: :unauthorized
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
        :fullname,
      )
  end
end
