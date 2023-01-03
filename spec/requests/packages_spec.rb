require "rails_helper"

RSpec.describe "/packages" do
  let!(:user) { create(:user1) }
  let!(:endpoint) { create(:endpoint1, user: user) }
  let!(:package) { create(:bundle1, user: user) }
  let!(:source) { create(:source1, package: package) }
  # TODO: To responses
  let!(:valid_bundle) do
    {
      name: "test-bundle",
      type: "Package::Bundle",
      caption: "Test6",
      short_description: "Test",
      description: "Test",
      root: :system_root,
      path: "Test"
    }
  end

  before do
    source.publish!
    package.publish!
  end

  describe "GET /index" do
    context "when user signed in" do
      include_context "when user is authenticated"

      it "renders a successful response" do
        get packages_path
        expect(response).to be_successful
      end
    end

    context "when not signed in" do
      it "redirects to login page" do
        get packages_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when endpoint signed in" do
      it "redirects to login page" do
        get packages_path(current_endpoint: endpoint)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /show" do
    context "when user signed in" do
      include_context "when user is authenticated"

      it "valid package renders a successful response" do
        get package_path(package)
        expect(response).to be_successful
      end

      it "valid user/package renders a successful response" do
        get "/user1/bundle1"
        expect(response).to be_successful
      end

      it "invalid package shows 404 error" do
        get package_path("error")
        expect(response).to have_http_status :not_found
      end
    end

    context "when not signed in" do
      it "valid package redirects a successful response" do
        get package_path(package)
        expect(response).to be_successful
      end

      it "valid user/package renders a successful response" do
        get "/user1/bundle1"
        expect(response).to be_successful
      end

      # TODO: :not_found
      it "invalid package redirects to login page" do
        get package_path("error")
        expect(response).to have_http_status :forbidden
      end
    end

    context "when endpoint signed in" do
      it "valid package renders a successful response" do
        get package_path(package, current_endpoint: endpoint)
        expect(response).to be_successful
      end

      it "invalid package shows 403 error" do
        get package_path("error")
        expect(response).to have_http_status :forbidden
      end
    end
  end

  describe "GET /new" do
    context "when user signed in" do
      include_context "when user is authenticated"

      it "renders a successful response" do
        get new_package_path
        expect(response).to be_successful
      end
    end

    context "when not signed in" do
      it "redirects to login page" do
        get new_package_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when endpoint signed in" do
      it "redirects to login page" do
        get new_package_path(current_endpoint: endpoint)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /edit" do
    context "when user signed in" do
      include_context "when user is authenticated"

      it "renders a successful response" do
        get edit_package_path(package)
        expect(response).to be_successful
      end
    end

    context "when not signed in" do
      it "redirects to login page" do
        get edit_package_path(package)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when endpoint signed in" do
      it "redirects to login page" do
        get edit_package_path(package, current_endpoint: endpoint)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /create" do
    context "when user signed in" do
      include_context "when user is authenticated"

      it "creates a new Package" do
        expect do
          post packages_path, params: { package: valid_bundle }
        end.to change(Package, :count).by(1)
        expect(response).to redirect_to(package_path(Package.last))
      end
    end

    context "when not signed in" do
      it "redirects to login page" do
        post packages_path, params: { package: valid_bundle }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when endpoint signed in" do
      it "redirects to login page" do
        get packages_path(current_endpoint: endpoint)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /update" do
    let(:new_attributes) do
      {
        short_description: "Test1"
      }
    end

    context "when signed in" do
      include_context "when user is authenticated"

      it "updates the requested package" do
        expect do
          patch package_path(package), params: { package: new_attributes }
          package.reload
        end.to change(package, :short_description).from("Test").to("Test1")
      end

      it "redirects to the package" do
        patch package_path(package), params: { package: new_attributes }
        package.reload
        expect(response).to redirect_to(package_path(package))
      end
    end

    context "when not signed in" do
      it "redirects to login page" do
        patch package_path(package), params: { package: new_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when endpoint signed in" do
      it "redirects to login page" do
        patch package_path(package, current_endpoint: endpoint), params: { package: new_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /destroy" do
    context "when user signed in" do
      include_context "when user is authenticated"

      it "destroys the requested package" do
        expect do
          delete package_path(package)
        end.to change(Package, :count).by(-1)
      end

      it "redirects to the packages list" do
        delete package_path(package)
        expect(response).to redirect_to(packages_path)
      end
    end

    context "when not signed in" do
      it "redirects to login page" do
        delete package_path(package)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when endpoint signed in" do
      it "redirects to login page" do
        delete package_path(package, current_endpoint: endpoint)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
