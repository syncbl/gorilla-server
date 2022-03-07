require "rails_helper"

RSpec.describe "/packages", type: :request do
  let(:user) { create(:user1) }
  let(:package) { create(:bundle1, user:) }
  let(:valid_bundle) do
    {
      name: "test-bundle",
      type: "Package::Bundle",
      caption: "Test6",
      short_description: "Test",
      description: "Test",
      user_id: user.id,
      root: :system_root,
      path: "Test",
    }
  end

  describe "GET /index" do
    context "when signed in" do
      before do
        sign_in user
      end

      it "renders a successful response" do
        get packages_url
        expect(response).to be_successful
      end
    end

    context "when not signed in" do
      it "redirects to login page" do
        get packages_url
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /show" do
    context "when signed in" do
      before do
        sign_in user
      end

      it "valid package renders a successful response" do
        get package_url(package)
        expect(response).to be_successful
      end

      it "invalid package shows 404 error" do
        get package_url("error")
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when not signed in" do
      it "valid package redirects to login page" do
        get package_url(package)
        expect(response).to redirect_to(new_user_session_path)
      end

      it "invalid package redirects to login page" do
        get package_url("error")
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /new" do
    context "when signed in" do
      before do
        sign_in user
      end

      it "renders a successful response" do
        get new_package_url
        expect(response).to be_successful
      end
    end

    context "when not signed in" do
      it "redirects to login page" do
        get packages_url
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /edit" do
    context "when signed in" do
      before do
        sign_in user
      end

      it "renders a successful response" do
        get edit_package_url(package)
        expect(response).to be_successful
      end
    end

    context "when not signed in" do
      it "redirects to login page" do
        get packages_url
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /create" do
    context "when signed in" do
      before do
        sign_in user
      end

      it "creates a new Package" do
        expect do
          post packages_url, params: { package: valid_bundle }
        end.to change(Package, :count).by(1)
        expect(response).to redirect_to(package_url(Package.last))
      end
    end

    context "when not signed in" do
      it "redirects to login page" do
        get packages_url
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /update" do
    context "when signed in" do
      before do
        sign_in user
      end

      let(:new_attributes) do
        {
          short_description: "Test1",
        }
      end

      it "updates the requested package" do
        package = Package::Bundle.create! valid_bundle
        expect do
          patch package_url(package), params: { package: new_attributes }
          package.reload
        end.to change { package.short_description }.from("Test").to("Test1")
      end

      it "redirects to the package" do
        package = Package::Bundle.create! valid_bundle
        patch package_url(package), params: { package: new_attributes }
        package.reload
        expect(response).to redirect_to(package_url(package))
      end
    end

    context "when not signed in" do
      it "redirects to login page" do
        get packages_url
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /destroy" do
    context "when signed in" do
      before do
        sign_in user
      end

      it "destroys the requested package" do
        package = Package::Bundle.create! valid_bundle
        expect do
          delete package_url(package)
        end.to change(Package, :count).by(-1)
      end

      it "redirects to the packages list" do
        package = Package::Bundle.create! valid_bundle
        delete package_url(package)
        expect(response).to redirect_to(packages_url)
      end
    end

    context "when not signed in" do
      it "redirects to login page" do
        get packages_url
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
