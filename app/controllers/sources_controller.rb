class SourcesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :deny_endpoint!, except: %i[index show]
  before_action :set_source, except: %i[index new create]
  before_action :check_edit_permissions!, only: %i[edit update delete]

  # GET /sources
  def index
    @sources = Source.all
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
    @source = Source.new(source_params)

    if @source.save
      redirect_to @source, notice: 'Source was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /sources/1
  def update
    if @source.update(source_params)
      redirect_to @source, notice: 'Source was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sources/1
  def destroy
    @source.destroy
    redirect_to sources_url, notice: 'Source was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # TODO: Ensure, we can access there only after authorization
  def set_source
    @source = Source.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def source_params
    params.fetch(:source, {})
  end

  def check_edit_permissions!
    # TODO: Permissions
    head :forbidden if @source.package.user.id != current_user.id
  end
end
