class EndpointsController < ApplicationController
  # TODO: Refactor access
  before_action :authenticate_user!, only: %i[index create]
  before_action :deny_endpoint!, only: %i[index create]
  before_action :set_endpoint, except: %i[index create]

  # GET /endpoints
  # GET /endpoints.json
  def index
    # TODO: Add group
    @pagy, @endpoints = pagy(current_user.endpoints)
  end

  # GET /endpoints/1
  # GET /endpoints/1.json
  def show; end

  # POST /endpoints.json
  def create
    @endpoint =
      current_user.endpoints.find_by(id: endpoint_params[:id]) ||
        current_user.endpoints.new(name: endpoint_params[:name])
    @endpoint.update({
      remote_ip: request.remote_ip
    })
    respond_to do |format|
      format.html { redirect_to endpoints_url }
      format.json { generate_token }
    end
  end

  # PATCH/PUT /endpoint
  # PATCH/PUT /endpoint.json
  def update
    respond_to do |format|
      if @package.update(package_params)
        format.html do
          redirect_to @package, notice: 'Endpoint was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @package }
      else
        format.html { render :edit }
        format.json do
          render json: @package.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /endpoints/1
  # DELETE /endpoints/1.json
  def destroy
    @endpoint.update(authentication_token: nil)

    # TODO: Do we need to keep this PC or delete it? May be it can be good to keep
    # in order to show list after login with available endpoints
    #@endpoint.discard
    sign_out current_user
    respond_to do |format|
      format.html do
        redirect_to endpoints_url,
                    notice: 'Endpoint was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /endpoint/install
  # PATCH/PUT /endpoint/install.json
  def install
    setting =
      @endpoint.install(
        Package.allowed_for(current_user).find_by_alias(params[:package])
      )
    respond_to do |format|
      if setting
        format.html do
          redirect_to endpoint_url, notice: 'Package soon will be installed.'
        end
        format.json { render :show, status: :accepted, location: @endpoint }
      else
        format.html { render :edit }
        format.json do
          render json: setting.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_endpoint
    if current_endpoint.present?
      @endpoint = current_endpoint
      if rand(ENDPOINT_TOKEN_REGEN_RANDOM) == 0
        @endpoint.update(authentication_token: nil)
        current_endpoint.new_token = JsonWebToken.encode(@endpoint)
      end
    elsif params[:id].present?
      @endpoint = current_user.endpoints.find(params[:id])
    else
      head :unauthorized
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def endpoint_params
    params.require(:endpoint).permit(:id, :name, :package)
  end
end
