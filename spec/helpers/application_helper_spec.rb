require "rails_helper"

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe "page title" do
    let!(:user) { create(:user1) }
    let!(:endpoint) { create(:endpoint1, user:) }
    let!(:package) { create(:bundle1, user:) }

    it "returns the default title" do
      expect(helper.page_title("")).to eq("Syncbl")
    end

    it "returns the user title" do
      expect(helper.page_title(user)).to eq(user.fullname)
    end

    it "returns the endpoint title" do
      expect(helper.page_title(endpoint)).to eq(endpoint.caption)
    end

    it "returns the package title" do
      expect(helper.page_title(package)).to eq("#{package.user.name}/#{package.name}")
    end
  end
end
