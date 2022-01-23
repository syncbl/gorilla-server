require "rails_helper"

RSpec.describe Package, type: :model do
  # it_behaves_like :blockable

  let(:user) {
    FactoryBot.create(:user1)
  }
  let(:component) {
    FactoryBot.create(:component, user: user)
  }
  let(:bundle) {
    FactoryBot.create(:bundle, user: user)
  }
  let(:external) {
    FactoryBot.create(:external, user: user)
  }

  context "Model" do
    it "Should be correct" do
      expect(component.package_type).to eq :component
      expect(bundle.package_type).to eq :bundle
      expect(external.package_type).to eq :external
    end
  end
end
