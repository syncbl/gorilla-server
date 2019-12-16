class PackagesController < ApplicationController
  before_action :authenticate_user!, except: [:release]
  before_action :set_package, only: [:show, :edit, :update, :destroy]

  # GET /packages
  # GET /packages.json
  def index
    #if current_user.company
    #  @packages = Package.where(user: current_user.company.users)
    @packages = Package.available_for(user: current_user)
  end

  # GET /packages/1
  # GET /packages/1.json
  def show
  end

  # GET /packages/new
  def new
    @package = Package.new
  end

  # GET /packages/1/edit
  def edit
  end

  # POST /packages
  # POST /packages.json
  def create
    @package = Package.new(package_params)

    respond_to do |format|
      if @package.save
        format.html { redirect_to @package, notice: 'Package was successfully created.' }
        format.json { render :show, status: :created, location: @package }
      else
        format.html { render :new }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /packages/1
  # PATCH/PUT /packages/1.json
  def update
    respond_to do |format|
      if @package.discarded_at.nil? && @package.update(package_params)
        format.html { redirect_to @package, notice: 'Package was successfully updated.' }
        format.json { render :show, status: :ok, location: @package }
      else
        format.html { render :edit }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /packages/1
  # DELETE /packages/1.json
  def destroy
    @package.destroy
    respond_to do |format|
      format.html { redirect_to packages_url, notice: 'Package was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /release.json
  def release
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package
      @package = Package.find_by(key: params[:id]) || Package.find_by(name: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def package_params
      params.fetch(:package, {})
    end
end
