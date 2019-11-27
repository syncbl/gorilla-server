class Users::SessionsController < Devise::SessionsController

  def create
    respond_to do |format|
      format.any(*navigational_formats) { super }
      format.json do
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)

        # -- We need to leave token for all the computers used --
        # -- But we need to control endpoints one by one --
        #if current_user
        #  current_user.authentication_token = ''
          # TODO: Counters, timeouts, etc.
          # TODO: Check for count of allowed endpoints etc.
          # TODO: Blockchain hash!
        #  current_user.save(touch: false)
        #end
        respond_with_authentication_token(resource)
      end
    end
  end

  protected

  def respond_with_authentication_token(resource)

    render json: {
      success: true,
      auth_token: resource.authentication_token,
      email: resource.email
    }
  end

end