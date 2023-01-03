require "rails_helper"

RSpec.describe EndpointsController do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/endpoint").to route_to("endpoints#show")
    end

    it "routes to #update via PUT" do
      expect(put: "/endpoint").to route_to("endpoints#update")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/endpoint").to route_to("endpoints#update")
    end
  end
end
