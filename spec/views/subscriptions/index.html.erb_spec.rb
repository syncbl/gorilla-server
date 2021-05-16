require 'rails_helper'

RSpec.describe "subscriptions/index", type: :view do
  before(:each) do
    assign(:subscriptions, [
      Subscription.create!(),
      Subscription.create!()
    ])
  end

  it "renders a list of subscriptions" do
    render
  end
end
