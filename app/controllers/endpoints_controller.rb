class EndpointsController < ApplicationController
  # TODO: Refactor access
  before_action :authenticate_user!, only: %i[index create destroy]
  before_action :set_endpoint, except: %i[index create]
  after_action :clear_cached, only: %i[update destroy]

  # GET /endpoints
  # GET /endpoints.json
  def index
    # TODO: Add group
    @pagy, @endpoints = pagy(
      policy_scope(Endpoint),
      items: params[:items]
    )
  end

  # GET /endpoints/1
  # GET /endpoints/1.json
  def show; end

  # POST /endpoints.json
  def create
    respond_to do |format|
      format.html { head :method_not_allowed }
      format.json do
        @endpoint = policy_scope(Endpoint).find_by(id: endpoint_params[:id]) ||
                    policy_scope(Endpoint).new(name: endpoint_params[:name])
        @endpoint.update({
          remote_ip: request.remote_ip, # TODO: Additional security by IP compare
          locale: current_user.locale,
        })
        sign_in_endpoint(@endpoint)
        render :show, status: :created, location: @endpoint
      end
    end
  end

  # PATCH/PUT /endpoint
  # PATCH/PUT /endpoint.json
  def update
    authorize @endpoint
    respond_to do |format|
      if @endpoint.update(endpoint_params)
        format.html do
          redirect_to @endpoint, notice: "Endpoint was successfully updated."
        end
        format.json { render :show, status: :ok, location: @endpoint }
      else
        format.html { render :edit }
        format.json do
          render json: @endpoint.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /endpoints/1
  # DELETE /endpoints/1.json
  def destroy
    authorize @endpoint
    @endpoint.update(authentication_token: nil)

    # TODO: Do we need to keep this PC or delete it? May be it can be good to keep
    # in order to show list after login with available endpoints
    #@endpoint.discard
    sign_out current_user
    respond_to do |format|
      format.html do
        redirect_to endpoints_url,
                    notice: "Endpoint was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_endpoint
    @endpoint = current_endpoint || current_user&.endpoints&.find(params[:id])
  end

  def clear_cached
    @endpoint.delete_cached
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def endpoint_params
    params.require(:endpoint).permit(:id, :name, :package)
  end
end
