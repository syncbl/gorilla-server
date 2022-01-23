class CloneEndpointService < ApplicationService
  def initialize(from_endpoint, to_endpoint)
    @from_endpoint = from_endpoint
    @to_endpoint = to_endpoint
  end

  def call
    return if @from_endpoint.nil? ||
              (@from_endpoint == @to_endpoint) ||
              (@from_endpoint.user != @to_endpoint.user)

    @from_endpoint.packages.each do |p|
      unless p.component? || @to_endpoint.installed?(p)
        @to_endpoint.notify :add_package, p
      end
    end
  end
end
