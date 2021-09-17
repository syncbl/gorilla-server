require "test_helper"

class PackagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @package = packages(:one)
    @new_package = {
      name: "p-bundle",
      package_type: :bundle,
      caption: '{"en": "Test Bundle"}',
      short_description: '{"en": "Test package"}',
      description: '{"en": "Test package"}',
    }
    sign_in(users(:one))
  end

  test "should get index" do
    get packages_url, as: :json
    assert_response :success
  end

  test "should create package" do
    #assert_difference("Package.count") do
    post packages_url, params: { package: @new_package },
                       as: :json
    puts response.body
    #end
    assert_response :created
  end

  test "should show package" do
    get package_url(@package), as: :json
    assert_response :success
  end

  test "should update package" do
    #patch package_url(@package), params: { package: { version: "2" } }
    #assert_redirected_to package_url(@package)
  end

  test "should destroy package" do
    assert_difference("Package.count", -1) {
      delete package_url(@package), as: :json
    }

    assert_redirected_to packages_url
  end
end
