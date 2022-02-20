module Authenticatable
  extend ActiveSupport::Concern

  def authenticate_endpoint!
    @endpoint =
      current_endpoint ||
      Endpoint.find_by(id: params[:endpoint_id] || params[:id], user: current_user)
    authorize @endpoint, :show?, policy_class: EndpointPolicy
  end
end
