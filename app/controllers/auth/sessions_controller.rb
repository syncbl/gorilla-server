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
        if params[:endpoint].nil?
          current_user.token = Api::Token.encode(resource)
          render "users/show"
        else
          id = params.dig("endpoint", "id")
          @endpoint = id.present? ?
            Endpoint.find(params.dig("endpoint", "id")) : current_user.endpoints.new
          @endpoint.update({
            name: params.dig("endpoint", "name"),
            remote_ip: request.remote_ip, # TODO: Additional security by IP compare
            locale: current_user.locale,
          })
          sign_in_endpoint @endpoint
          render "endpoints/show"
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
