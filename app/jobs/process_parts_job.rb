class ProcessPartsJob < ApplicationJob
  queue_as :default

  def perform(package, checksum)
    return false if package.parts.empty?

    source = package.sources.create
    if attachment = ActiveStorage::Blob.find_by(checksum: checksum)
      source.attachment = attachment
      source.save
    else
      tmpfilename = Dir::Tmpname.create(['syncbl-', '.tmp']) {}
      File.open(tmpfilename, 'wb') do |tmpfile|
        package.parts.each do |file|
          file.open do |f|
            tmpfile.write(File.open(f.path, 'rb').read)
          end
        end
      end

      # TODO: Make sure zip is OK and build packet structure
      #Zip::File.open(tmpfilename) do |z|
      #  zip.each do |z|
      #    puts "+++ #{z.name}"
      #  end
      #end

      filename = Time.now.strftime('%Y%m%d%H%M%S') + '.zip'
      source.attachment.attach(io: File.open(tmpfilename), filename: filename)
      File.delete(tmpfilename)
    end
    package.parts.purge_later
    if source.attachment.checksum == checksum
      # TODO: Update manifest
      package.size += source.attachment.byte_size
      package.save
    else
      # TODO: Block package/user, inform admin
      source.destroy
    end
  end
end
