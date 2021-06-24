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
        if params[:endpoint].present?
          @endpoint = Endpoint.find(params[:endpoint])
          if @endpoint.user_id != current_user.id
            @endpoint.update(user: current_user)
          end
          sign_in_endpoint @endpoint
          render "endpoints/show"
        else
          current_user.token = Api::Token.encode(resource)
          render "users/show"
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      format.any(*navigational_formats) { super }
      format.json do
        current_user.regenerate_authentication_token
      end
    end
  end
end
