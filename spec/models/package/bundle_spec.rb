require "rails_helper"

RSpec.describe Package::Bundle do
  # it_behaves_like :blockable

  let(:user) { create(:user1) }
  let(:component1) { create(:component1, user: user) }
  let(:component2) { create(:component2, user: user) }
  let(:bundle1) { create(:bundle1, user: user) }
  let(:bundle2) { create(:bundle2, user: user) }

  context "with components" do
    # describe "With components" do

    before do
      bundle1.dependent_packages << bundle2
      bundle1.dependent_packages << component1
      bundle1.dependent_packages << component2
    end

    it "contains components" do
      expect(bundle1.dependencies.size).to eq 3
    end
    # end
  end
end
