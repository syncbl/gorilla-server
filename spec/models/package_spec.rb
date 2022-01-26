require "rails_helper"

RSpec.describe Package, type: :model do
  # it_behaves_like :blockable

  let(:user) do
    create(:user1)
  end
  let(:component) do
    create(:component1, user:)
  end
  let(:bundle) do
    create(:bundle1, user:)
  end
  let(:external) do
    create(:external1, user:)
  end

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
