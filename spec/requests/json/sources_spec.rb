require "rails_helper"

RSpec.describe "Sources" do
  describe "GET show" do
    context "when user signed in" do
      include_context "when user is authenticated"

      let!(:endpoint) { create(:endpoint1, user: user) }
      let!(:package) { create(:bundle1, user: user) }
      let!(:source) { create(:source1, package: package) }

      # it "valid source renders a successful response" do
      # TODO: Fix to use package_source_path(package, source)
      # get package_source_path(source, params: { package_id: package.id })
      # expect(response).to be_successful
      # end
    end
  end
end
