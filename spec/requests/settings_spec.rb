require 'rails_helper'

RSpec.describe "Settings", type: :request do
  let!(:user) { create(:user1) }
  let!(:endpoint) { create(:endpoint1, user:) }
  let!(:bundle1) { create(:bundle1, user:) }
  let!(:component1) { create(:component1, user:) }
  let!(:component2) { create(:component2, user:) }
  # let!(:bundle2) { create(:bundle2, user:) }
  let(:source1) { create(:source1, package: bundle1) }

  before do
    bundle1.dependent_packages << component1
    component1.dependent_packages << component2
    PackageInstallService.call([bundle1], endpoint)
  end

  describe "GET /endpoint/settings" do
    it "renders a successful response" do
      get endpoint_settings_path(current_endpoint: endpoint), params: {
        packages: source1.id.to_s
      }
      expect(response).to have_http_status(:ok)
    end
  end
end
