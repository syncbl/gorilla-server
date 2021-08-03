class PackagesController < ApplicationController
  before_action :authenticate_user!, except: %i[show search]
  before_action :set_package, except: %i[index new create search]

  # GET /packages
  # GET /packages.json
  def index
    @pagy, @packages =
      pagy_countless(
        policy_scope(Package),
        items: params[:items],
      )
  end

  # GET /packages/1
  # GET /packages/1.json
  def show
    authorize @package
  end

  # GET /packages/new
  def new
    @package = policy_scope(Package).new
  end

  # GET /packages/1/edit
  def edit; end

  # POST /packages
  # POST /packages.json
  def create
    respond_to do |format|
      if @package = policy_scope(Package).create(package_params)
        format.html do
          redirect_to @package, notice: "Package was successfully created."
        end
        format.json { render :show, status: :created, location: @package }
      else
        format.html { render :new }
        format.json do
          render json: @package.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /packages/1
  # PATCH/PUT /packages/1.json
  def update
    authorize @package
    respond_to do |format|
      if @package.update(package_params)
        format.html do
          redirect_to @package, notice: "Package was successfully updated."
        end
        format.json { render :show, status: :ok, location: @package }
      else
        format.html { render :edit }
        format.json do
          render_json_error @package.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /packages/1
  # DELETE /packages/1.json
  def destroy
    authorize @package
    respond_to do |format|
      if @package.destroy
        format.html do
          redirect_to packages_url,
                      notice: "Package was successfully destroyed."
        end
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json do
          render_json_error @package.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  # TODO: Move it to index
  def search
    @packages = Package.published.search_by_text(params[:q]).limit(15)
    #.keep_if { |p| authorize p }
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  def set_package
    @package = if params[:user_id].present?
        Package.where(user: { name: params[:user_id] })
          .find_by!(name: params[:id])
      else
        Package.where(id: params[:id])
          .or(Package::External.where(name: params[:id]))
          .first
      end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # <input type="text" name="client[name]" value="Acme" />
  def package_params
    params.require(:package).permit(:name, :external_url, :replacement)
  end
end
