class EndpointsController < ApplicationController
  before_action :authenticate_user!, only: %i[index destroy]
  before_action :set_endpoint, only: %i[show update]

  # GET /endpoints
  # GET /endpoints.json
  def index
    @pagy, @endpoints =
      pagy_countless(policy_scope(Endpoint), items: params[:items])
  end

  # GET /endpoints/1
  # GET /endpoints/1.json
  def show
    authorize @endpoint
  end

  # POST /endpoints.json
  # TODO: Change everything! Updates for current_endpoint to PUT!
  def create
    respond_to do |format|
      format.html { head :method_not_allowed }
      format.json do
        @endpoint = Endpoint.new
        @endpoint.update(
          {
            name: endpoint_params[:name],
            user: current_user,
            remote_ip: request.remote_ip,
            locale: I18n.default_locale.to_s,
          },
        )
        sign_in_endpoint @endpoint
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
          redirect_to @endpoint, notice: 'Endpoint was successfully updated.'
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
    authorize @endpoint
    respond_to do |format|
      if @endpoint.destroy
        format.html do
          redirect_to endpoints_url,
                      notice: 'Endpoint was successfully destroyed.'
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_endpoint
    @endpoint = current_endpoint || Endpoint.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def endpoint_params
    params.require(:endpoint).permit(:id, :name, :package)
  end
end
