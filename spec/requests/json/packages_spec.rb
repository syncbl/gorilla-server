require "rails_helper"

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe Package, type: :request do
  let!(:user) { create(:user1) }
  let!(:package) { create(:bundle1, user:) }
  let!(:source) { create(:source1, package:) }

  before do
    source.publish!
    package.publish!
  end

  describe "GET show" do
    context "when signed in" do
      include_context "when user is authenticated"

      it "renders a successful response" do
        get package_path(package, format: :json)

        expect(response).to be_successful
        expect(JSON.parse(response.body, symbolize_names: true)).to match(
          Responses::Packages.show_valid(package)
        )
      end
    end

    context "when not signed in" do
      it "renders a successful response" do
        get package_path(package, format: :json)

        expect(response).to be_successful
        expect(JSON.parse(response.body, symbolize_names: true)).to match(
          Responses::Packages.show_valid(package)
        )
      end
    end
  end

  describe "GET search" do
    let!(:valid_response) do
      {
        name: package.relative_name
      }
    end

    context "when signed in" do
      include_context "when user is authenticated"

      it "renders a successful response" do
        get search_packages_path(q: "Bundle", format: :json)

        expect(response).to be_successful
        expect(JSON.parse(response.body)["response"][0]).to include_json(valid_response)
      end
    end

    context "when not signed in" do
      it "renders a successful response" do
        get search_packages_path(q: "Bundle", format: :json)

        expect(response).to be_successful
        expect(JSON.parse(response.body)["response"][0]).to include_json(valid_response)
      end
    end
  end
end
