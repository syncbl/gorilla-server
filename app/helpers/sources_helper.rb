module SourcesHelper
  def write_tmp(file)
    tmpfilename = Dir::Tmpname.create(%w[source- .tmp]) { }
    File.open(tmpfilename, "wb") { |tmpfile| tmpfile.binwrite(file.read) }
    tmpfilename
  end

  def source_exists?(user, size, checksum)
    if ids = ActiveStorage::Attachment.where(
      record_type: "Source",
      blob: ActiveStorage::Blob.where(
        byte_size: size,
        checksum: checksum,
      ),
    )
      Source.find_by(id: ids.record_id, package: { user: user })
    end
  end
end
