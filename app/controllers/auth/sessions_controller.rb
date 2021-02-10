class Auth::SessionsController < Devise::SessionsController
  def create
    respond_to do |format|
      format.any(*navigational_formats) { super }
      format.json do
        old_session = session.to_hash
        reset_session
        session.update old_session.except("session_id")
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)
        current_user.new_token = JsonWebToken.encode(resource)
        render 'devise/sessions/create'
      end
    end
  end

  def destroy
    current_user.regenerate_authentication_token
    super
  end
end
