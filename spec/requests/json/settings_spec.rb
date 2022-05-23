require 'rails_helper'

RSpec.describe "Settings", type: :request do
  let!(:user) { create(:user1) }
  let!(:endpoint) { create(:endpoint1, user:) }
  let!(:bundle1) { create(:bundle1, user:) }
  let!(:component1) { create(:component1, user:) }
  let!(:component2) { create(:component2, user:) }
  # let!(:bundle2) { create(:bundle2, user:) }
  let(:source1) { create(:source1, package: bundle1) }
  let(:source2) { create(:source2, package: bundle1) }

  before do
    bundle1.dependent_packages << component1
    component1.dependent_packages << component2
    PackageInstallService.call([bundle1, component1], endpoint)
  end

  # TODO: Wrong uuid, unauthorized, notification to install components

  describe "GET /settings" do
    let!(:valid_response) do
      {
        settings: []
      }
    end

    # TODO: fix this
    it "renders a successful response" do
      get endpoint_settings_path(current_endpoint: endpoint, format: :json), params: {
        packages: source1.id.to_s
      }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body, symbolize_names: true)).to match(valid_response)
    end
  end
end
