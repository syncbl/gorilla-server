class SourcesController < ApplicationController
  include SourcesHelper
  before_action :authenticate_user!
  before_action :set_source, except: %i[index new create merge]

  # GET /sources
  def index
    @sources = current_user.packages.find(params[:package_id]).sources
  end

  # GET /sources/1
  def show
    authorize! :show, @source
  end

  # GET /sources/new
  def new
    @source = Source.new
  end

  # GET /sources/1/edit
  def edit; end

  # TODO: DirectUpload must be used here, but we still need to process the file
  # URL must be checked to be from S3 server.

  # POST /sources
  def create
    # Params removed from create() because user must fill fields only after creation
    @package = current_user.packages.find(file_params[:package_id])
    authorize! :show, @package
    check_source_exists
    @source = @package.sources.new
    respond_to do |format|
      if @source.save
        ProcessSourceJob.perform_later @source, write_tmp(file_params[:file])
        format.html do
          redirect_to [@package, @source],
                      notice: "You will receive notification when source is ready."
        end
        format.json do
          render :show, status: :created, location: [@package, @source]
        end
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
    authorize! :update, @source
    respond_to do |format|
      if @source.update(source_params)
        redirect_to @source, notice: "Source was successfully updated."
      else
        format.html { render :edit }
        format.json do
          render_json_error @package.errors.full_messages,
                            status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /sources/1
  def destroy
    authorize! @source
    respond_to do |format|
      if @source.destroy
        format.html do
          redirect_to sources_url, notice: "Source was successfully destroyed."
        end
        format.json { head :no_content }
      else
        format.html { render :show }
        format.json do
          render_json_error @source.errors.full_messages,
                            status: :unprocessable_entity
        end
      end
    end
  end

  # POST /package/1/sources/merge
  def merge
    @package = current_user.packages.find(params[:package_id])
    authorize! :update, @package
    respond_to do |format|
      format.html do
        if @package.sources.merged?
          head :unprocessable_entity
        else
          MergeSourcesJob.perform_later current_user.packages.find(
            params[:package_id],
          )
          head :accepted
        end
      end
      format.json { head :method_not_allowed }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_source
    if @package = current_user.packages
                              .find_by(package_id: params[:package_id])
      @source = @package.sources.find(params[:id])
    end
  end

  # Only allow a trusted parameter "white list" through.
  def source_params
    params.require(:source).permit(:description)
  end

  def file_params
    %i[file package_id checksum]
      .each_with_object(params) do |key, obj|
      obj.require(key)
    end
  end
end
