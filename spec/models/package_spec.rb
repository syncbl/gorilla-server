require "rails_helper"

RSpec.describe Package, type: :model do
  # it_behaves_like :blockable

  let(:user) { create(:user1) }
  let(:component) { create(:component1, user:) }
  let(:bundle) { create(:bundle1, user:) }
  let(:external) { create(:external1, user:) }

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
