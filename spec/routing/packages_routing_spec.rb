require "rails_helper"

RSpec.describe PackagesController do
  describe "routing" do
    context "with default routes" do
      it "routes to #index" do
        expect(get: "/packages").to route_to("packages#index")
      end

      it "routes to #new" do
        expect(get: "/packages/new").to route_to("packages#new")
      end

      it "routes to #show" do
        expect(get: "/packages/1").to route_to("packages#show", id: "1")
      end

      it "routes to #edit" do
        expect(get: "/packages/1/edit").to route_to("packages#edit", id: "1")
      end

      it "routes to #create" do
        expect(post: "/packages").to route_to("packages#create")
      end

      it "routes to #update via PUT" do
        expect(put: "/packages/1").to route_to("packages#update", id: "1")
      end

      it "routes to #update via PATCH" do
        expect(patch: "/packages/1").to route_to("packages#update", id: "1")
      end

      it "routes to #destroy" do
        expect(delete: "/packages/1").to route_to("packages#destroy", id: "1")
      end
    end

    context "with custom routes" do
      it "routes to #show" do
        expect(get: "/user1/package1").to route_to("packages#show", user_id: "user1", package_id: "package1")
      end

      it "routes to #search" do
        expect(get: "/packages/search").to route_to("packages#search")
      end

      it "routes to source#show" do
        expect(get: "/packages/1/sources/1").to route_to("sources#show", package_id: "1", id: "1")
      end

      it "routes to source#merge" do
        expect(get: "/packages/1/sources/merge").to route_to("sources#show", package_id: "1", id: "merge")
      end
    end
  end
end
