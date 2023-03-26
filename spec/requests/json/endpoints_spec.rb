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

RSpec.describe Endpoint do
  let!(:user) { create(:user1) }
  let!(:endpoint) { create(:endpoint1, user: user) }

  describe "GET show" do
    let(:valid_response) do
      EndpointResponse.new.build(:show_valid, endpoint)
    end

    it "renders a successful response" do
      get endpoint_path(format: :json, current_endpoint: endpoint)
      expect(response).to be_successful
      expect(response.parsed_body).to match valid_response
    end
  end
end
