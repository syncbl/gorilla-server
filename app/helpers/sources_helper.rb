module SourcesHelper
  def write_tmp(file)
    tmpfilename = Dir::Tmpname.create(%w[s- .tmp]) { }
    File.open(tmpfilename, "wb") { |tmpfile| tmpfile.write(file.read) }
    tmpfilename
  end

  def source_exists?(user, size, checksum)
    id = ActiveStorage::Attachment.find_by(
      record_type: "Source",
      blob: ActiveStorage::Blob.find_by(
        byte_size: size,
        checksum: checksum,
      ),
    )&.record_id
    id && Source.find_by(id: id)&.package&.user.id == user.id
  end
end
