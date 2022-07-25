class EndpointResponse < Response
  def show_valid(endpoint)
    {
      response_type: "endpoint",
      response: {
        id: endpoint.id,
        caption: endpoint.caption,
        locale: endpoint.locale,
      },
    }
  end
end
