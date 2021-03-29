module SourcesHelper
  def write_tmp(file)
    tmpfilename = Dir::Tmpname.create(%w[s- .tmp]) { }
    File.open(tmpfilename, "wb") do |tmpfile|
      tmpfile.write(file.read)
    end
    tmpfilename
  end

  def find_source(user, size, checksum)
    Source.find_by(
      id: ActiveStorage::Attachment.find_by(
        record_type: "Source",
        blob: ActiveStorage::Blob.find_by(
          byte_size: size,
          checksum: checksum
        )
      ).record_id
    )&.package&.user.id == user.id
  end
end
