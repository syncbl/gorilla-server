require "rails_helper"

RSpec.describe User, type: :model do
  it_behaves_like :blockable

  let(:user) { FactoryBot.create(:user1) }

  #context ''

end
