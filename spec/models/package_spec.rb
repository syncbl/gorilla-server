require "rails_helper"

RSpec.describe Package do
  let(:user) { create(:user1) }
  let(:component) { create(:component1, user: user) }
  let(:bundle) { create(:bundle1, user: user) }
  let(:external) { create(:external1, user: user) }

  # TODO: subject should be its it_behaves_like :blockable

  context "with package params" do
    it "is correct component" do
      expect(component).to be_component
    end

    it "is correct bundle" do
      expect(bundle).to be_bundle
    end

    it "is correct external" do
      expect(external).to be_external
    end
  end
end
