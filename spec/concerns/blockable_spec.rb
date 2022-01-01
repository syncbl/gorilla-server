require "rails_helper"

RSpec.shared_examples_for :blockable do
  let(:user) { FactoryBot.create(:user1) }

  context "when blocked" do
    before :each do
      user.block!
    end

    it "should became marked as blocked" do
      expect(user.blocked_at).to_not be_nil
    end
  end
end
