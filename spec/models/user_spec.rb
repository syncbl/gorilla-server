require "rails_helper"

RSpec.describe User, type: :model do
  # it_behaves_like :blockable

  let(:user) { create(:user1) }

  context "with package params" do
    it "is correct component" do
      # expect(user).to be_component
    end
  end
end
