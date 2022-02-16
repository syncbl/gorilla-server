class CloneEndpointService < ApplicationService
  def initialize(from_endpoint, to_endpoint)
    @from_endpoint = from_endpoint
    @to_endpoint = to_endpoint
  end

  def call
    return if @from_endpoint.nil? ||
              (@from_endpoint == @to_endpoint) ||
              (@from_endpoint.user != @to_endpoint.user)

    @from_endpoint.packages
                  .reject { |p| p.component? || @to_endpoint.installed?(p) }
                  .each do |p|
      @to_endpoint.notify_add_package(p)
    end
  end
end
