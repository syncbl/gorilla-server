module SourcesHelper
  def write_tmp(file)
    Dir::Tmpname.create(%w[source- .tmp]) do |path|
      File.binwrite(path, file.read)
    end
  end

  def source_exists?(user, size, checksum)
    if ids = ActiveStorage::Attachment.where(
      record_type: "Source",
      blob: ActiveStorage::Blob.where(
        byte_size: size,
        checksum:,
      ),
    )
      Source.includes(:package)
            .find_by(id: ids.last&.record_id, package: { user: })
    end
  end

  def check_source_exists
    return unless source_exists?(current_user, file_params[:file].size, params[:checksum])

    # TODO: Link to source
    flash[:warning] = I18n.t("warnings.attributes.source.file_already_exists")
  end
end
