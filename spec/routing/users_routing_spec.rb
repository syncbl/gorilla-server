require "rails_helper"

RSpec.describe UsersController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/user1").to route_to("users#show", id: "user1")
      expect(get: "/user").to route_to("users#show")
    end

    it "routes to #edit" do
      expect(get: "/user/edit").to route_to("users#edit")
    end

    it "routes to #update via PUT" do
      expect(put: "/user").to route_to("users#update")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/user").to route_to("users#update")
    end
  end
end
