class PackagesController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_package, except: %i[index new create]
  before_action :check_permissions!, only: %i[update destroy]

  # GET /packages
  # GET /packages.json
  def index
    @pagy, @packages =
      pagy_countless(
        current_user.packages.includes(:icon_attachment),
        items: params[:items],
      )
  end

  # GET /packages/1
  # GET /packages/1.json
  def show; end

  # GET /packages/new
  # TODO: Store in cache during edit to allow update page
  def new
    @package = current_user.packages.new
  end

  # GET /packages/1/edit
  def edit; end

  # POST /packages
  # POST /packages.json
  def create
    @package = current_user.packages.create(package_params)
    respond_to do |format|
      if @package.save
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

  private

  # Use callbacks to share common setup or constraints between actions.

  def set_package
    packages = Package.published_with(current_user).joins(:user)
    @package = params[:user_id].present? ?
      packages.where(user: { name: params[:user_id] }).find_by!(name: params[:package_id]) :
      packages.find_any!(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # <input type="text" name="client[name]" value="Acme" />
  def package_params
    params.require(:package).permit(:name, :external_url, :replacement)
  end

  def check_permissions!
    check_edit! @package
  end
end
