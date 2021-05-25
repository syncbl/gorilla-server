class SourcesController < ApplicationController
  include SourcesHelper
  before_action :authenticate_user!
  before_action :set_source, except: %i[index new create merge attach]
  before_action :check_file_params, only: %i[create]
  before_action :check_permissions!, only: %i[update destroy]

  # GET /sources
  def index
    @sources = current_user.packages.find(params[:package_id]).sources
  end

  # GET /sources/1
  def show
    check_view! @source.package
  end

  # GET /sources/new
  def new
    @source = Source.new
  end

  # GET /sources/1/edit
  def edit; end

  # POST /sources
  def create
    # Params removed from create() because user must fill fields only after creation
    @source = current_user.packages.find_by!(id: params[:package_id])&.
      sources.create(size: params[:file].size)
    respond_to do |format|
      if @source.save
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
    check_edit! @source.package
    respond_to do |format|
      if @source.update(source_params)
        redirect_to @source, notice: "Source was successfully updated."
      else
        format.html { render :edit }
        format.json do
          render_json_error @package.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /sources/1
  def destroy
    check_edit! @source.package
    respond_to do |format|
      if @source.destroy
        format.html do
          redirect_to sources_url, notice: "Source was successfully destroyed."
        end
        format.json { head :no_content }
      else
        format.html { render :show }
        format.json do
          render_json_error @source.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  # POST /package/1/sources/merge
  def merge
    check_edit! @source.package
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

  def check_permissions!
    check_edit! @source.package
  end
end
