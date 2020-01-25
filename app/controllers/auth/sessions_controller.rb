class Auth::SessionsController < Devise::SessionsController

  def create
    respond_to do |format|
      format.any(*navigational_formats) { super }
      format.json do
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)
        @endpoint = Endpoint.find_by(user: resource, key: params[:user][:endpoint]) ||
                    Endpoint.new(user: resource)
        if @endpoint.new_record?
          @endpoint.save
          @endpoint.reload
        else
          @endpoint.regenerate_authentication_token
        end
        respond_with_authentication_token(resource)
      end
    end
  end

  def destroy
    respond_to do |format|
      format.any(*navigational_formats) { super }
      format.json do
        current_user&.endpoint&.regenerate_authentication_token
      end
    end
  end

  protected

  def respond_with_authentication_token(resource)
    render json: {
      version: Rails.application.config.api_version,
      session: {
        endpoint: @endpoint.key,
        token: @endpoint.authentication_token
      }
    }
  end
end