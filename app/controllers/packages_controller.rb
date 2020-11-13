class PackagesController < ApplicationController
  # We allowing anonymous access
  before_action :authenticate_user!, except: [:index, :show]
  before_action :deny_endpoint!, except: [:index, :show]
  before_action :set_package, except: [:index, :new, :create]
  before_action :check_edit_permissions!, only: [:edit, :update, :delete]

  # GET /packages
  # GET /packages.json
  def index
    @pagy, @packages = pagy(Package.allowed_for(current_user).includes([:icon_attachment]),
      items: package_params[:items])
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
    @package = Package.new(package_post_params)
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
    if package_params[:method] == 'clear_parts'
      @package.parts.purge_later
      head :accepted
    elsif package_params[:method] == 'clear_all'
      @package.parts.purge_later
      @package.sources.destroy_all
      head :accepted
    elsif package_params[:method] == 'store_parts'
      # TODO: Update marker in package to check if jobs were successful
      ProcessPartsJob.perform_later(@package, package_params[:checksum])
      #FlattenUpdatesJob.perform_later(@package)
      head :accepted
    elsif package_params[:part].present?
      @package.parts.attach(package_params[:part])
      head :accepted
    else
      respond_to do |format|
        if @package.update(package_post_params)
          format.html { redirect_to @package, notice: 'Package was successfully updated.' }
          format.json { render :show, status: :ok, location: @package }
        else
          format.html { render :edit }
          format.json { render json: @package.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /packages/1
  # DELETE /packages/1.json
  def destroy
    respond_to do |format|
      if @package.destroy
        format.html { redirect_to packages_url, notice: 'Package was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  def set_package
    @package = Package.allowed_for(current_user).find_by_alias(package_params[:id])
  end

  def check_edit_permissions!
    # TODO: Permissions
    if @package.user.id != current_user.id
      head :forbidden
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # TODO: require(:package)
  # <input type="text" name="client[name]" value="Acme" />
  def package_post_params
    params.require(:package).permit(:name, :external_url, :alias)
  end

  def package_params
    params.permit(:id, :file, :part, :checksum, :method, :items)
  end

end
