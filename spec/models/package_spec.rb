require "rails_helper"

RSpec.describe Package, type: :model do
  # it_behaves_like :blockable

  let(:bundle1) { FactoryBot.create(:bundle1) }
  let(:bundle2) { FactoryBot.create(:bundle2) }
  let(:component1) { FactoryBot.create(:component1) }
  let(:component2) { FactoryBot.create(:component2) }

  context "Bundle" do
    it "Should contain components" do
      expect(bundle1.dependencies.size).to eq 2
    end
  end
end
