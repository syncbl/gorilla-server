RSpec.shared_context "when user is authenticated" do
  let!(:user) { create(:user1) }

  before do
    sign_in user
  end
end
