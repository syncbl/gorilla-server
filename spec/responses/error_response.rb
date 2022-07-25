class ErrorResponse < Response
  def component_error
    {
      errors: {
        packages: ["Validation failed: Package Can't install component without corresponding bundle"],
      },
    }
  end

  def not_found(id)
    {
      error: "Couldn't find Package with 'id'=#{id}",
    }
  end

  def bad_request
    {
      error: "param is missing or the value is empty: packages",
    }
  end
end
