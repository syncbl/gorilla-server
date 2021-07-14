class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]

  # GET /subscriptions/1
  def show
  end

  # POST /subscriptions
  def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.save
      redirect_to @subscription, notice: "Subscription was successfully created."
    else
      render :new
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subscription
    @subscription = current_user.subscriptions.current.take
  end

  # Only allow a list of trusted parameters through.
  def subscription_params
    params.fetch(:subscription, {})
  end
end
