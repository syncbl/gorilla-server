require 'rails_helper'

RSpec.describe "Sources" do
  let!(:user) { create(:user1) }
  let!(:endpoint) { create(:endpoint1, user: user) }
  let!(:package) { create(:bundle1, user: user) }

  describe "POST /create" do
    context "when user signed in" do
      include_context "when user is authenticated"

      it "creates a new Source" do
        expect do
          post package_sources_path(package), params: {
            file: Rack::Test::UploadedFile.new(
              File.open(Rails.root.join("files/test1.zip"))
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
        post package_sources_path(package), params: {
          file: Rack::Test::UploadedFile.new(
            File.open(Rails.root.join("files/test1.zip"))
          ),
          checksum: "test"
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when endpoint signed in" do
      it "redirects to login page" do
        post package_sources_path(package, current_endpoint: endpoint), params: {
          file: Rack::Test::UploadedFile.new(
            File.open(Rails.root.join("files/test1.zip"))
          ),
          checksum: "test"
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
