class EndpointsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_endpoint, only: [:show, :edit, :update, :destroy]

  # GET /endpoints
  # GET /endpoints.json
  def index
    # TODO: Add company
    @endpoints = current_user.endpoints.actual
  end

  # GET /endpoints/1
  # GET /endpoints/1.json
  def show
  end

  # GET /endpoints/1/edit
  def edit
  end

  # PATCH/PUT /endpoints/1
  # PATCH/PUT /endpoints/1.json
  def update
    respond_to do |format|
      if @endpoint.update(endpoint_params)
        format.html { redirect_to @endpoint, notice: 'Endpoint was successfully updated.' }
        format.json { render :show, status: :ok, location: @endpoint }
      else
        format.html { render :edit }
        format.json { render json: @endpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /endpoints/1
  # DELETE /endpoints/1.json
  def destroy
    @endpoint.destroy
    respond_to do |format|
      format.html { redirect_to endpoints_url, notice: 'Endpoint was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # TODO: Differ access from API and access from web.
    def set_endpoint
      @endpoint = current_user.endpoint
      if @endpoint.nil?
        head :forbidden
      else
        @endpoint.regenerate_authentication_token
        current_user.endpoint_new_token = JsonWebToken.encode(@endpoint)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def endpoint_params
      params.fetch(:endpoint, {})
    end
end
