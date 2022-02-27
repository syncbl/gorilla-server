require "rails_helper"

RSpec.describe "/packages", type: :request do
  let(:user) { create(:user1) }

  let(:valid_bundle) {
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
  }

  describe "GET /index" do
    context "when signed in" do
      before do
        sign_in user
      end

      it "renders a successful response" do
        Package::Bundle.create! valid_bundle
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
      it "renders a successful response" do
        package = Package::Bundle.create! valid_bundle
        get package_url(package)
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
        package = Package::Bundle.create! valid_bundle
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
      context "with valid parameters" do
        it "creates a new Package" do
          expect {
            post packages_url, params: { package: valid_bundle }
          }.to change(Package, :count).by(1)
        end

        it "redirects to the created package" do
          post packages_url, params: { package: valid_bundle }
          expect(response).to redirect_to(package_url(Package.last))
        end
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
      context "with valid parameters" do
        let(:new_attributes) {
          {
            caption: "Test1",
          }
        }

        it "updates the requested package" do
          package = Package::Bundle.create! valid_bundle
          expect {
            patch package_url(package), params: { package: new_attributes }
            package.reload
          }.to change { package.caption }.from("Test6").to("Test1")
        end

        it "redirects to the package" do
          package = Package::Bundle.create! valid_bundle
          patch package_url(package), params: { package: new_attributes }
          package.reload
          expect(response).to redirect_to(package_url(package))
        end
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
        expect {
          delete package_url(package)
        }.to change(Package, :count).by(-1)
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
