class EndpointResponse < Response
  def show_valid(endpoint)
    {
      response_type: "endpoint",
      response: {
        id: endpoint.id,
        name: endpoint.name,
        locale: endpoint.locale
      }
    }
  end
end
