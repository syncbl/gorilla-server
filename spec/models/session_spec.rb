require "rails_helper"

RSpec.describe Session do
  let(:session) { create(:session) }
  let(:user) { create(:user1) }
  let(:endpoint) { create(:endpoint1, user: user) }

  context "with session create" do
    it "is correct user" do
      session.update(resource: user)
      expect(session.resource).to eq user
    end

    it "is correct endpoint" do
      session.update(resource: endpoint)
      expect(session.resource).to eq endpoint
    end
  end
end
