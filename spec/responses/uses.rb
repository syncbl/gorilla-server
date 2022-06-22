module Responses
  module Users
    module_function

    def show_valid(user)
      {
        response_type: "user",
        response: {
          id: user.id,
          name: user.name,
          fullname: user.fullname,
          locale: user.locale,
        },
      }.with_indifferent_access
    end
  end
end
