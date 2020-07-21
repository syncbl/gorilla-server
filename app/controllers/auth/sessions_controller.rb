class Auth::SessionsController < Devise::SessionsController

  def create
    old_session = session.to_hash
    reset_session
    session.update old_session.except('session_id')
    respond_to do |format|
      format.any(*navigational_formats) { super }
      format.json do
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)
        register_endpoint(params[:user][:endpoint])
      end
    end
  end

end
