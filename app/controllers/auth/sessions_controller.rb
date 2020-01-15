  class Auth::SessionsController < Devise::SessionsController

  def create
    respond_to do |format|
      format.any(*navigational_formats) { super }
      format.json do
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)

        @endpoint = Endpoint.find_by(user: resource, key: params[:user][:endpoint]) ||
                    Endpoint.create(user: resource)

        respond_with_authentication_token(resource)
      end
    end
  end

  protected

  def respond_with_authentication_token(resource)
    render json: {
      version: Rails.application.config.api_version,
      session: {
        endpoint: @endpoint.reload.key,
        token: @endpoint.authentication_token
      }
    }
  end

end