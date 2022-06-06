class Auth::SessionsController < Devise::SessionsController
  after_action :reset_token!, only: :create,
                              if: -> { request.format.json? }

  def create
    respond_to do |format|
      format.any(*navigational_formats) { super }
      format.json do
        # TODO: Move to ApplicationController
        clear_session
        if params[:endpoint].nil?
          self.resource = warden.authenticate!(auth_options)
          sign_in(resource_name, resource)
          render "users/show"
        else
          id = params.dig("endpoint", "id")
          @endpoint = id.present? ? Endpoint.find_by(id:) : Endpoint.new
          @endpoint.update(
            {
              user: current_user,
              caption: params.dig("endpoint", "caption"),
              remote_ip: request.remote_ip,
              locale: current_user.locale,
            }
          )
          sign_in_endpoint @endpoint
          render "endpoints/show"
        end
      end
    end
  end

  def destroy
    reset_session
    respond_to do |format|
      format.any(*navigational_formats) { super }
      format.json do
        current_user.regenerate_authentication_token
      end
    end
  end

  private

  def clear_session
    old_session = session.to_hash
    reset_session
    session.update old_session.except("session_id")
  end
end
