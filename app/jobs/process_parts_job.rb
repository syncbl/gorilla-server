class ProcessPartsJob < ApplicationJob
  queue_as :default

  def perform(package, checksum)
    return false if package.parts.empty?

    source = package.sources.new
    if file = ActiveStorage::Blob.find_by(checksum: checksum)
      source.file = file
    else
      tmpfilename = Dir::Tmpname.create(['syncbl-', '.tmp']) {}
      File.open(tmpfilename, 'wb') do |tmpfile|
        package.parts.each do |file|
          file.open do |f|
            tmpfile.write(File.open(f.path, 'rb').read)
          end
          file.destroy
        end
      end
      filename = Time.now.strftime('%Y%m%d%H%M%S') + '.zip'
      # TODO: Make sure zip is deleted if fault
      unpacked_size = 0
      Zip::File.open(tmpfilename) do |zipfile|
        zipfile.each do |z|
          if (z.size > MAX_FILE_SIZE)
            package.block_reason = "zip: #{filename}, #{z.name}, #{z.size}"
            package.blocked_at = Time.current
            break
          end
          unpacked_size += z.size
        end
      end
      source.file.attach(io: File.open(tmpfilename), filename: filename)
      File.delete(tmpfilename)
    end
    if source.file.checksum == checksum
      # TODO: Update manifest
      source.save
      package.size += unpacked_size
      package.save
    else
      # TODO: Block package/user, inform admin
      source.destroy
    end
  end
end
