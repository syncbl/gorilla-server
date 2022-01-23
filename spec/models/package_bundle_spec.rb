require "rails_helper"

RSpec.describe Package::Bundle, type: :model do
  # it_behaves_like :blockable

  let(:user) {
    FactoryBot.create(:user1)
  }
  let(:component1) {
    FactoryBot.create(:component1, user: user)
  }
  let(:component2) {
    FactoryBot.create(:component2, user: user)
  }
  let(:bundle1) {
    FactoryBot.create(:bundle1, user: user)
  }
  let(:bundle2) {
    FactoryBot.create(:bundle2, user: user)
  }

  context "With components" do
    #describe "With components" do
    it "Should contain components" do
      bundle1.dependent_packages << bundle2
      bundle1.dependent_packages << component1
      bundle1.dependent_packages << component2

      expect(bundle1.dependencies.size).to eq 3
    end

    it "Should contain components" do
      bundle1.dependent_packages << component1
      bundle1.dependent_packages << component2

      expect(bundle1.dependencies.size).to eq 2
    end
    #end
  end
end
