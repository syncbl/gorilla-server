class ProcessPartsJob < ApplicationJob
  queue_as :default

  def perform(package, checksum)
    return false if package.parts.empty?

    tmpfilename = Dir::Tmpname.create(['sncbl-', '.tmp']) {}
    File.open(tmpfilename, 'wb') do |tmpfile|
      package.parts.each do |file|
        file.open do |f|
          tmpfile.write(File.open(f.path, 'rb').read)
        end
      end
    end
    package.parts.purge

    # TODO: Make sure zip is OK and build packet structure
    #Zip::File.open(tmpfilename) do |z|
    #  zip.each do |z|
    #    puts "+++ #{z.name}"
    #  end
    #end

    filename = Time.now.strftime('%Y%m%d%H%M%S') + '.sncbl-package'
    attachment = package.attachments.create
    attachment.archive.attach(io: File.open(tmpfilename), filename: filename)
    if attachment.archive.checksum == checksum
      # TODO: Update manifest
      package.size += attachment.archive.byte_size
      package.save
    else
      # TODO: Block package/user, inform admin
      attachment.destroy
    end
    File.delete(tmpfilename)
  end
end
