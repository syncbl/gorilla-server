class SourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_endpoint!
  before_action :set_source, except: %i[index new create]
  before_action :check_edit_permissions!, except: %i[index show create]

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
    # Params removed from create() because user must fill fields only after creation
    @source = current_user.packages.find(params[:package_id])&.sources.create

    tmpfilename = Dir::Tmpname.create(%w[syncbl- .tmp]) { }
    File.open(tmpfilename, "wb") do |tmpfile|
      tmpfile.write(params[:file].read)
    end
    ProcessSourceJob.perform_later(@source,
                                   filename: tmpfilename,
                                   checksum: params[:checksum])

    respond_to do |format|
      if @source.persisted?
        format.html { redirect_to [@source.package, @source], notice: "Source was successfully created." }
        format.json { render :show, status: :created, location: [@source.package, @source] }
      else
        puts @source.errors.messages
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_source
    @source = current_user.packages.find_by(package_id: params[:package_id])&.
      sources.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def source_params
    params.require(:source).permit(:description)
  end

  def check_edit_permissions!
    # TODO: Permissions
    render status: :forbidden if @source.package.user.id != current_user.id
  end
end
