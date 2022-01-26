require "rails_helper"

RSpec.describe Package::Bundle, type: :model do
  # it_behaves_like :blockable

  let(:user) do
    FactoryBot.create(:user1)
  end
  let(:component1) do
    FactoryBot.create(:component1, user: user)
  end
  let(:component2) do
    FactoryBot.create(:component2, user: user)
  end
  let(:bundle1) do
    FactoryBot.create(:bundle1, user: user)
  end
  let(:bundle2) do
    FactoryBot.create(:bundle2, user: user)
  end

  context "With components" do
    # describe "With components" do

    before(:each) do
      bundle1.dependent_packages << bundle2
      bundle1.dependent_packages << component1
      bundle1.dependent_packages << component2
    end

    it "Should contain components" do
      expect(bundle1.dependencies.size).to eq 3
    end
    # end
  end
end
