class EndpointsController < ApplicationController
  before_action :authenticate_user!
  before_action :forbid_for_endpoint!, only: %i[index destroy]
  before_action :authenticate_endpoint!, only: %i[show update clone]
  before_action :set_endpoint, only: %i[update destroy clone]
  authorize_resource except: %i[show clone]

  # GET /endpoints
  # GET /endpoints.json
  def index
    @pagy, @endpoints =
      pagy_countless(current_user.endpoints, items: params[:items])
  end

  # GET /endpoints/1
  # GET /endpoints/1.json
  def show
    @endpoint = current_endpoint
    authorize! :show, @endpoint
    # TODO: @endpoint.touch
  end

  # POST /endpoints.json
  def create
    respond_to do |format|
      format.html { head :method_not_allowed }
      format.json do
        @endpoint = Endpoint.create!({
                                       name: endpoint_params[:name],
                                       user: current_user,
                                       remote_ip: request.remote_ip,
                                       locale: I18n.default_locale,
                                     })
        sign_in_endpoint @endpoint
        render :show, status: :created, location: @endpoint
      end
    end
  end

  # PATCH/PUT /endpoint
  # PATCH/PUT /endpoint.json
  def update
    respond_to do |format|
      if @endpoint.update(endpoint_params)
        format.html do
          redirect_to @endpoint, notice: "Endpoint was successfully updated."
        end
        format.json { render :show, status: :ok, location: @endpoint }
      else
        format.html { render :edit }
        format.json do
          render_json_error @endpoint.errors.full_messages,
                            status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /endpoints/1
  # DELETE /endpoints/1.json
  def destroy
    respond_to do |format|
      if @endpoint.destroy
        format.html do
          redirect_to endpoints_url,
                      notice: "Endpoint was successfully destroyed."
        end
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json do
          render_json_error @endpoint.errors.full_messages,
                            status: :unprocessable_entity
        end
      end
    end
  end

  # POST /endpoint/clone
  # POST /endpoint/clone.json
  def clone
    from_endpoint = if params[:from_endpoint_id]
        Endpoint.find(params[:from_endpoint_id])
      else
        Endpoint.where.not(id: @endpoint.id).order(updated_at: :desc).first
      end
    authorize! :show, from_endpoint
    authorize! :update, @endpoint
    CloneEndpointService.call(from_endpoint, @endpoint)
    respond_to do |format|
      format.html do
        redirect_to @endpoint, notice: "Endpoint was successfully cloned."
      end
      format.json { render :show, status: :created, location: @endpoint }
    end
  end

  private

  def set_endpoint
    @endpoint = Endpoint.find(params[:endpoint_id] || params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def endpoint_params
    params.require(:endpoint).permit(:id, :name, :package)
  end
end
