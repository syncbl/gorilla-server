class SourcesController < ApplicationController
  before_action :authenticate_user!
  # TODO: before_action :deny_endpoint!, except: %i[index show]
  before_action :set_source, except: %i[index new create]
  before_action :check_edit_permissions!, except: %i[index show]

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
    @source.package_id ||= params[:package_id]
    @source.save!

    tmpfilename = Dir::Tmpname.create(%w[s- .tmp]) {}
    File.open(tmpfilename, 'wb') do |tmpfile|
      tmpfile.write(params[:file].read)
    end
    ProcessSourceJob.perform_later(@source,
      filename: tmpfilename,
      checksum: params[:checksum]
    )

    #@source.file.attach(params[:file])

    respond_to do |format|
      if @source.persisted?
        format.html { redirect_to [@source.package, @source], notice: 'Source was successfully created.' }
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
    @source = Source.find_by!(id: params[:id], package_id: params[:package_id])
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
