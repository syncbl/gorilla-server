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
      expect(component.component?).to be_truthy
      expect(bundle.bundle?).to be_truthy
      expect(external.external?).to be_truthy
    end
  end
end
