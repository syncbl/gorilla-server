require "rails_helper"

RSpec.describe Package::Bundle, type: :model do
  # it_behaves_like :blockable

  let(:user) do
    create(:user1)
  end
  let(:component1) do
    create(:component1, user:)
  end
  let(:component2) do
    create(:component2, user:)
  end
  let(:bundle1) do
    create(:bundle1, user:)
  end
  let(:bundle2) do
    create(:bundle2, user:)
  end

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
