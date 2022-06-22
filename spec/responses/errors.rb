module Responses
  module Errors
    module_function

    def component_error
      {
        errors: {
          packages: ["Validation failed: Package Can't install component without corresponding bundle"],
        },
      }.with_indifferent_access
    end

    def not_found(id)
      {
        error: "Couldn't find Package with 'id'=#{id}"
      }.with_indifferent_access
    end

    def bad_request
      {
        error: "param is missing or the value is empty: packages"
      }.with_indifferent_access
    end
  end
end
