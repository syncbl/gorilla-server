class PackagesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_package, except: [:index, :new, :create]
  before_action :limit_scope_user, only: [:create, :edit, :update, :delete]

  # GET /packages
  # GET /packages.json
  def index
    #if current_user.company
    #  @packages = Package.where(user: current_user.company.users)
    if user_signed_in?
      @packages = Package.allowed_to(current_user)
    else
      @packages = Package.for_all
    end
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
    if params[:attachment] == 'purge'
      # We can't purge files, just because some of the customers can be in a middle of update
      @package.parts.purge_later
      head :no_content
    elsif params[:attachment] == 'store'
      # TODO: Move to files to keep all versions for this package
      JoinPartsToFileJob.perform_later(@package, params[:checksum])
      head :no_content
    elsif params[:part].present?
      @package.parts.attach(params[:part])
      head :no_content
    else
      respond_to do |format|
        if @package.update(package_params)
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
      if @package.discard
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
      @package = Package.find_by(id: params[:id]) || Package.find_by!(alias: params[:id])
    end

    def limit_scope_user
      head :forbidden if (current_user.endpoint.present? || (@package.user != current_user))
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def package_params
      params.permit(:name, :text, :version)
    end
end
