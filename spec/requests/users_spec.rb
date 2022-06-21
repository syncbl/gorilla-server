require "rails_helper"

RSpec.describe "/users", type: :request do
  # TODO: For a new user
  # let(:new_user_attributes) {
  #   FactoryBot.attributes_for(:user1, name: "user3", email: "user3@example.com")
  # }

  describe "GET /show" do
    context "when signed in" do
      include_context "when user is authenticated"

      it "renders a successful response for me" do
        get user_path
        expect(response).to be_successful
      end

      it "renders a successful response for user1" do
        get "/user1"
        expect(response).to be_successful
      end
    end

    context "when not signed in" do
      it "renders an unsuccessful response for me" do
        get user_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it "renders a successful response for user1" do
        get "/user1"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /edit" do
    context "when signed in" do
      include_context "when user is authenticated"

      it "renders a successful response" do
        get edit_user_path(user)
        expect(response).to be_successful
      end
    end

    context "when not signed in" do
      let!(:user) { create(:user1) }

      it "renders an unsuccessful response" do
        get edit_user_path(user)
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "PATCH /update" do
    let(:valid_attributes) do
      {
        fullname: "Test Test",
      }
    end
    let(:invalid_attributes) do
      {
        email: "123",
      }
    end

    include_context "when user is authenticated"

    context "with valid parameters" do
      it "updates the requested user" do
        patch user_path, params: { user: valid_attributes }
        user.reload
        expect(user.fullname).to eq "Test Test"
      end

      it "redirects to the user" do
        patch user_path, params: { user: valid_attributes }
        user.reload
        expect(response).to redirect_to(user_path)
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        patch user_path, params: { user: invalid_attributes }
        expect(response).not_to be_successful
      end
    end
  end
end
