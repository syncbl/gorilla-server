class ProcessPartsJob < ApplicationJob
  queue_as :default

  def perform(package, checksum, replace)
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

    filename = Time.now.strftime('%Y%m%d%H%M%S') + '.sncz'
    if (replace == true) || !package.archive.attached?
      package.archive.purge
      package.archive.attach(io: File.open(tmpfilename), filename: filename)
      if package.archive.checksum == checksum
        # TODO: Update manifest
        package.size = package.archive.byte_size
        package.save
      else
        # TODO: Block package/user, inform admin
        package.archive.destroy
      end
    else
      package.updates.attach(io: File.open(tmpfilename), filename: filename)
      if package.updates.last.checksum == checksum
        # TODO: Update manifest
        #package.save
      else
        # TODO: Block package/user, inform admin
        package.updates.last.destroy
      end
    end
    File.delete(tmpfilename)
  end
end
