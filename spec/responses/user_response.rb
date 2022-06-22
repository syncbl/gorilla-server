class UserResponse
  include ResponseHelper

  private

  def show_valid(user)
    {
      response_type: "user",
      response: {
        id: user.id,
        name: user.name,
        fullname: user.fullname,
        locale: user.locale,
      },
    }
  end
end
