module SourcesHelper
  def write_tmp(file)
    tmpfilename = Dir::Tmpname.create(%w[s- .tmp]) {}
    File.open(tmpfilename, "wb") { |tmpfile| tmpfile.binwrite(file.read) }
    tmpfilename
  end

  def source_exists?(user, size, checksum)
    ids = ActiveStorage::Attachment.where(
      record_type: "Source",
      blob: ActiveStorage::Blob.where(
        byte_size: size,
        checksum: checksum,
      ),
    )&.record_id
    Source.find_by(id: ids, package: { user: user })
  end
end
