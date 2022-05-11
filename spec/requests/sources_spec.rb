require 'rails_helper'

RSpec.describe "Sources", type: :request do
  include Authentication

  let!(:user) { create(:user1) }
  let!(:endpoint) { create(:endpoint1, user:) }
  let!(:package) { create(:bundle1, user:) }

  describe "POST /create" do
    context "when user signed in" do
      before do
        sign_in user
      end

      it "creates a new Source" do
        expect do
          post package_sources_url(package), params: {
            file: Rack::Test::UploadedFile.new(
              File.open(Rails.root.join("files/test1.zip")),
            ),
            checksum: "test"
          }
        end.to change(Source, :count).by(1)

        expect(response).to redirect_to(
          [package, Source.last]
        )

        perform_enqueued_jobs
        assert_performed_jobs 1

        expect(Source.last.file.attached?).to be true
      end
    end

    context "when not signed in" do
      it "redirects to login page" do
        post package_sources_url(package), params: {
          file: Rack::Test::UploadedFile.new(
            File.open(Rails.root.join("files/test1.zip")),
          ),
          checksum: "test"
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when endpoint signed in" do
      before do
        sign_in_endpoint endpoint
      end

      it "redirects to login page" do
        post package_sources_url(package), params: {
          file: Rack::Test::UploadedFile.new(
            File.open(Rails.root.join("files/test1.zip")),
          ),
          checksum: "test"
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
