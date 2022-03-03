class PlansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan, only: %i[show]

  # GET /plans/1
  def show; end

  # POST /plans
  def create
    @plan = Plan.new(plan_params)

    if @plan.save
      redirect_to @plan,
                  notice: 'plan was successfully created.'
    else
      render :new
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_plan
    @plan = current_user.plans.current.take
  end

  # Only allow a list of trusted parameters through.
  def plan_params
    params.fetch(:plan, {})
  end
end
