class Auth::RegistrationsController < Devise::RegistrationsController

  def create
    respond_to do |format|
      format.any(*navigational_formats) { super }
      format.json do
        @user = User.new(registration_params)
        if @user.save
          sign_in @user
          register_endpoint(params[:user][:endpoint])
        else
          render json: @user.errors, status: :unauthorized
        end
      end
    end
  end

  protected

  def registration_params
    # TODO: Sanitize endpoint
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :locale, :endpoint)
    #params.permit(:endpoint).permit(:uuid, :name)
  end
end