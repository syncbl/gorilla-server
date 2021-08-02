class PackagesController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_package, except: %i[index new create]

  # GET /packages
  # GET /packages.json
  # TODO: Components
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
  # TODO: Store in cache during edit to allow update page
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

  def search
    packages = Package.search_by_text(params[:q])
      .keep_if { |p| authorize p }
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  def set_package
    @package = params[:user_id].present? ?
      Package.where(user: { name: params[:user_id] })
      .find_by!(name: params[:package_id]) :
      Package.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # <input type="text" name="client[name]" value="Acme" />
  def package_params
    params.require(:package).permit(:name, :external_url, :replacement)
  end
end
