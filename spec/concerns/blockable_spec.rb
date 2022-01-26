require "rails_helper"

RSpec.shared_examples_for 'blockable' do
  let(:user) { create(:user1) }

  context "when blocked" do
    before do
      user.block!
    end

    it "becames marked as blocked" do
      expect(user.blocked_at).not_to be_nil
    end
  end
end
