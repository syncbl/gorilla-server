require "rails_helper"

RSpec.describe "Settings", type: :request do
  let!(:user) { create(:user1) }
  let!(:endpoint) { create(:endpoint1, user:) }

  let!(:bundle1) { create(:bundle1, user:) }
  let!(:component1) { create(:component1, user:) }
  let!(:component2) { create(:component2, user:) }

  let(:bundle2) { create(:bundle2, user:) }
  let!(:component3) { create(:component3, user:) }

  let!(:source1) { create(:source1, package: bundle1) }
  let!(:source2) { create(:source2, package: bundle1) }

  before do
    bundle1.dependent_packages << component1
    PackageInstallService.call(endpoint, bundle1)
    component1.dependent_packages << component2
    bundle2.dependent_packages << component3
  end

  # TODO: Wrong uuid, unauthorized, notification to install components
  # TODO: Correct response - why component1?
  # TODO: INDEX (short), GET (full), POST (full + not installed deps + all src), SYNC (show sources, no params)
  describe "GET index" do
    # TODO: Valid response must contain component1
    let!(:valid_response) do
      settings_short_response(bundle1)
    end

    # TODO: fix this
    it "renders a successful response" do
      get endpoint_settings_path(current_endpoint: endpoint, format: :json), params: {
        packages: source1.id.to_s,
      }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body, symbolize_names: true)).to match(valid_response)
    end
  end

  describe "POST create" do
    context "when package id is provided" do
      let!(:valid_response) do
        settings_long_response(component1, component2)
      end

      let!(:invalid_response) do
        { errors: { packages: ["Validation failed: Package Can't install component without corresponding bundle"] } }
      end

      it "renders a successful response for components" do
        post endpoint_settings_path(current_endpoint: endpoint, format: :json), params: {
          packages: [component1.id, component2.id],
        }
        expect(response).to have_http_status(:accepted)
        expect(JSON.parse(response.body, symbolize_names: true)).to match(valid_response)
        expect(Setting.all.size).to eq(3)
      end

      it "renders an unsuccessful response for other components" do
        post endpoint_settings_path(current_endpoint: endpoint, format: :json), params: {
          packages: [component3.id],
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body, symbolize_names: true)).to match(invalid_response)
        expect(Setting.all.size).to eq(1)
      end
    end

    context "when user_id/package_id is provided" do
      let!(:valid_response) do
        {
          response_type: "setting",
          response: {
            active: true,
            package: {
              caption: component2.caption,
              category: component2.category,
              h_size: nil,
              id: component2.id,
              name: "#{component2.user.name}/#{component2.name}",
              package_type: component2.package_type.to_s,
              short_description: component2.short_description,
              size: 0,
              version: nil,
            },
            params: {
              path: "TEST1",
            },
            sources: [],
          },
        }
      end

      # TODO: fix this
      it "renders a successful response" do
        post endpoint_settings_path(current_endpoint: endpoint, format: :json), params: {
          user_id: component2.user.name, package_id: component2.name.to_s,
        }
        expect(response).to have_http_status(:accepted)
        expect(JSON.parse(response.body, symbolize_names: true)).to match(valid_response)
      end
    end
  end
end
