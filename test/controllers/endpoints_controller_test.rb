require 'test_helper'

class EndpointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @endpoint = endpoints(:one)
    sign_in(users(:one))
  end

  test "should get index" do
    get endpoints_url
    assert_response :success
  end

  test "should show endpoint" do
    get endpoint_url(@endpoint)
    assert_response :success
  end

  test "should get edit" do
    get edit_endpoint_url(@endpoint)
    assert_response :success
  end
end
