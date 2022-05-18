require "rails_helper"

RSpec.describe "/users", type: :request do
  # TODO: For a new user
  # let(:new_user_attributes) {
  #   FactoryBot.attributes_for(:user1, name: "user3", email: "user3@example.com")
  # }

  let(:user) { create(:user1) }

  describe "GET /show" do
    context "when signed in" do
      before do
        sign_in user
      end

      it "renders a successful response for me" do
        get user_url
        expect(response).to be_successful
      end

      it "renders a successful response for user1" do
        get "/user1"
        expect(response).to be_successful
      end
    end

    context "when not signed in" do
      it "renders an unsuccessful response for me" do
        get user_url
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
      before do
        sign_in user
      end

      it "renders a successful response" do
        get edit_user_url(user)
        expect(response).to be_successful
      end
    end

    context "when not signed in" do
      it "renders an unsuccessful response" do
        get edit_user_url(user)
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

    before do
      sign_in user
    end

    context "with valid parameters" do
      it "updates the requested user" do
        patch user_url, params: { user: valid_attributes }
        user.reload
        expect(user.fullname).to eq "Test Test"
      end

      it "redirects to the user" do
        patch user_url, params: { user: valid_attributes }
        user.reload
        expect(response).to redirect_to(user_url)
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        patch user_url, params: { user: invalid_attributes }
        expect(response).not_to be_successful
      end
    end
  end
end
