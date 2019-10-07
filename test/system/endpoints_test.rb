require "application_system_test_case"

class EndpointsTest < ApplicationSystemTestCase
  setup do
    @endpoint = endpoints(:one)
  end

  test "visiting the index" do
    visit endpoints_url
    assert_selector "h1", text: "Endpoints"
  end

  test "creating a Endpoint" do
    visit endpoints_url
    click_on "New Endpoint"

    click_on "Create Endpoint"

    assert_text "Endpoint was successfully created"
    click_on "Back"
  end

  test "updating a Endpoint" do
    visit endpoints_url
    click_on "Edit", match: :first

    click_on "Update Endpoint"

    assert_text "Endpoint was successfully updated"
    click_on "Back"
  end

  test "destroying a Endpoint" do
    visit endpoints_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Endpoint was successfully destroyed"
  end
end
