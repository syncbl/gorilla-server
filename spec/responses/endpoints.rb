module Responses
  module Endpoints
    module_function

    def show_valid(endpoint)
      {
        response_type: "endpoint",
        response: {
          id: endpoint.id,
          caption: endpoint.caption,
          locale: endpoint.locale
        },
      }.with_indifferent_access
    end
  end
end
