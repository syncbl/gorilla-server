class SourcesController < ApplicationController
  include SourcesHelper
  before_action :authenticate_user!
  before_action :set_source, except: %i[index new create merge]
  before_action :check_file_params, only: %i[create]

  # GET /sources
  def index
    @sources = current_user.packages.find(params[:package_id]).sources
  end

  # GET /sources/1
  def show; end

  # GET /sources/new
  def new
    @source = Source.new
  end

  # GET /sources/1/edit
  def edit; end

  # POST /sources
  def create
    # Params removed from create() because user must fill fields only after creation
    respond_to do |format|
      if @source = current_user.packages.find_by!(id: params[:package_id])&.sources.create
        if file = source_exists?(current_user, params[:file].size, params[:checksum])
          # TODO: Warn about existing file if it's own or public
        end
        ProcessSourceJob.perform_later @source, write_tmp(params[:file])
        #end
        format.html { redirect_to [@source.package, @source], notice: "Source was successfully created." }
        format.json { render :show, status: :created, location: [@source.package, @source] }
      else
        format.html { render :new }
        format.json do
          render json: @source.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /sources/1
  def update
    if @source.update(source_params)
      redirect_to @source, notice: "Source was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /sources/1
  def destroy
    @source.destroy
    redirect_to sources_url, notice: "Source was successfully destroyed."
  end

  # POST /package/1/sources/merge
  def merge
    @package = current_user.packages.find(params[:package_id])
    if @package.sources.merged?
      head :unprocessable_entity
    else
      MergeSourcesJob.perform_later current_user.packages.find(params[:package_id])
      head :accepted
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_source
    @source = current_user.packages.find_by(package_id: params[:package_id])&.
      sources.find(params[:id])
  end

  def check_file_params
    %i[package_id file checksum].all? { |s| params[s].present? }
  end

  # Only allow a trusted parameter "white list" through.
  def source_params
    params.require(:source).permit(:description)
  end
end
