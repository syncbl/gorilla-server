class PackagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_package, except: [:index]

  # GET /packages
  # GET /packages.json
  def index
    #if current_user.company
    #  @packages = Package.where(user: current_user.company.users)
    @packages = Package.kept.where(user: current_user, trusted: false).or(Package.where(trusted: true))
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
    @package.user = current_user
    respond_to do |format|
      if @package.save
        @package.reload
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
      if (@package.user == current_user) && @package.update(package_params)
        @package.files.purge if (params[:filename] == '')
        if params[:file].present?
          @package.files.attach(params[:file])
          @package.filename = nil
        end
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
    respond_to do |format|
      if (@package.user == current_user) && @package.discard
        format.html { redirect_to packages_url, notice: 'Package was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # TODO: Allow only for API!
  def install
    @setting = current_user.endpoint.settings.new(package: @package)
    respond_to do |format|
      if @setting.save
        format.html { redirect_to packages_url, notice: 'Package soon will be installed.' }
        format.json { render :show, status: :created, location: @package }
      else
        format.html { render :show }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def uninstall
    @setting = current_user.endpoint.settings.find_by(package: @package)
    respond_to do |format|
      if @setting&.destroy
        format.html { redirect_to packages_url, notice: 'Package was successfully uninstalled.' }
        format.json { render :show, status: :created, location: @package }
      else
        format.html { render :show }
        format.json { head :no_content, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package
      @package = Package.find_by('key = ? OR alias = ?', params[:id], params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def package_params
      params.permit(:name, :text, :version, :discarded_at, :filename, :checksum, :manifest)
    end
end
