class EndpointsController < ApplicationController
  before_action :authenticate_user!
  before_action :limit_scope, except: [:index]
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

  def install
    respond_to do |format|
      if @endpoint.install(params[:package])
        format.html { redirect_to endpoints_url, notice: 'Package soon will be installed.' }
        format.json { render :show, status: :created, location: @endpoint }
      else
        format.html { render :show }
        format.json { render json: @endpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  def uninstall
    respond_to do |format|
      if @endpoint.uninstall(params[:package])
        format.html { redirect_to endpoints_url, notice: 'Package was successfully uninstalled.' }
        format.json { render :show, status: :created, location: @endpoint }
      else
        format.html { render :show }
        format.json { render json: @endpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # TODO: Differ access from API and access from web.
    # ActiveRecord::RecordNotFound only with find_by
    def set_endpoint
      @endpoint = current_user.endpoint
      @endpoint.regenerate_authentication_token
      current_user.endpoint_new_token = JsonWebToken.encode(@endpoint)
    end

    def limit_scope
      if current_user.endpoint.nil?
        head :forbidden
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def endpoint_params
      params.fetch(:endpoint, {})
    end
end
