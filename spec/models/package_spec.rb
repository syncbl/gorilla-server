require "rails_helper"

RSpec.describe Package, type: :model do
  # it_behaves_like :blockable

  let(:user) do
    FactoryBot.create(:user1)
  end
  let(:component) do
    FactoryBot.create(:component1, user: user)
  end
  let(:bundle) do
    FactoryBot.create(:bundle1, user: user)
  end
  let(:external) do
    FactoryBot.create(:external1, user: user)
  end

  context "Model" do
    it "Should be correct" do
      expect(component.component?).to be_truthy
      expect(bundle.bundle?).to be_truthy
      expect(external.external?).to be_truthy
    end
  end
end
