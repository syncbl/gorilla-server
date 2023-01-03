require "rails_helper"

RSpec.describe "Settings" do
  let!(:setting_mock) { SettingResponse.new }

  let!(:user) { create(:user1) }
  let!(:endpoint) { create(:endpoint1, user: user) }

  let!(:bundle1) { create(:bundle1, user: user) }
  let!(:component1) { create(:component1, user: user) }
  let!(:component2) { create(:component2, user: user) }

  let(:bundle2) { create(:bundle2, user: user) }
  let!(:component3) { create(:component3, user: user) }

  let!(:source1) { create(:source1, :published, package: bundle1) }
  let!(:source2) { create(:source2, :published, package: bundle1, ancestor: source1) }
  let!(:source3) { create(:source1, :published, package: bundle2) }
  let!(:source4) { create(:source2, package: component3) }

  before do
    bundle1.dependent_packages << component1
    PackageInstallService.call(endpoint, [bundle1])
    component1.dependent_packages << component2
    bundle2.dependent_packages << component3
  end

  # TODO: Wrong uuid, unauthorized, notification to install components
  # TODO: Correct response - why component1?
  # TODO: INDEX (short), GET (full), POST (full + not installed deps + all src), SYNC (show sources, no params)
  describe "GET index" do
    # TODO: fix this
    it "renders a successful response" do
      get endpoint_settings_path(current_endpoint: endpoint, format: :json), params: {
        packages: source1.id.to_s
      }

      expect(response).to have_http_status :ok
      expect(JSON.parse(response.body)).to match(
        setting_mock.build(:index_valid, bundle1)
      )
    end
  end

  describe "GET show" do
    let!(:wrong_id) { SecureRandom.uuid }

    it "renders a successful response" do
      get endpoint_setting_path(bundle1, current_endpoint: endpoint, format: :json)

      expect(response).to have_http_status :ok
      expect(JSON.parse(response.body)).to match(
        setting_mock.build(:show_valid, bundle1, component1)
      )
    end

    it "renders an unsuccessful response for the wrong bundle" do
      get endpoint_setting_path(wrong_id, current_endpoint: endpoint, format: :json)

      expect(response).to have_http_status :not_found
      expect(JSON.parse(response.body)).to match(
        ErrorResponse.new.build(:not_found, wrong_id)
      )
    end
  end

  describe "POST create" do
    context "when package_id is provided" do
      let!(:wrong_id) { SecureRandom.uuid }

      it "renders a successful response for the components" do
        post endpoint_settings_path(current_endpoint: endpoint, format: :json), params: {
          packages: [component1.id, component2.id]
        }

        expect(response).to have_http_status :accepted
        expect(JSON.parse(response.body)).to match(
          setting_mock.build(:post_valid, component1, component2)
        )
        expect(Setting.all.size).to eq(3)
      end

      it "renders an unsuccessful response for the other components" do
        post endpoint_settings_path(current_endpoint: endpoint, format: :json), params: {
          packages: [component3.id]
        }

        expect(response).to have_http_status :unprocessable_entity
        expect(JSON.parse(response.body)).to match(
          ErrorResponse.new.build(:component_error)
        )
        expect(Setting.all.size).to eq(1)
      end

      it "renders an unsuccessful response for the wrong bundle" do
        post endpoint_settings_path(current_endpoint: endpoint, format: :json), params: {
          packages: [wrong_id]
        }

        expect(response).to have_http_status :not_found
        expect(JSON.parse(response.body)).to match(
          ErrorResponse.new.build(:not_found, wrong_id)
        )
      end

      it "renders an unsuccessful response for the bad id" do
        post endpoint_settings_path(current_endpoint: endpoint, format: :json), params: {
          packages: ["bad_id"]
        }

        expect(response).to have_http_status :not_found
        expect(JSON.parse(response.body)).to match(
          ErrorResponse.new.build(:not_found, "bad_id")
        )
      end
    end

    context "when package_id is not provided" do
      it "renders an unsuccessful response" do
        post endpoint_settings_path(current_endpoint: endpoint, format: :json)

        expect(response).to have_http_status :bad_request
        expect(JSON.parse(response.body)).to match ErrorResponse.new.build(:bad_request)
      end
    end
  end

  describe "POST sync" do
    context "when source ids were provided" do
      it "renders a successful response" do
        post sync_endpoint_settings_path(current_endpoint: endpoint, format: :json), params: {
          sources: [bundle1.sources.first.id]
        }

        expect(response).to have_http_status :accepted
        # TODO: notifications -> add_package
        # TODO: { id: source_id } IS IT ENOUGH???
        expect(JSON.parse(response.body)["response"].first).to match(
          setting_mock.build(:sync_valid, source2)
        )
        # expect(Setting.all.size).to eq(3)
      end
    end
  end

  # describe "?" do
  #  context "when user_id/package_id is provided" do

  # TODO: fix this
  #    it "renders a successful response" do
  #      post endpoint_settings_path(current_endpoint: endpoint, format: :json), params: {
  #        user_id: component2.user.name, package_id: component2.name.to_s,
  #      }
  #      expect(response).to have_http_status :accepted
  #      expect(JSON.parse(response.body)).to match(valid_response)
  #    end
  #  end
  # end
end
