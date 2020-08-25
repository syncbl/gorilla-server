class ProcessPartsJob < ApplicationJob
  # TODO: ???
  queue_as :default

  # TODO: We are sending :checksum, need to include it in perform to check is checksum = real checksum
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
    # TODO: Make sure zip is OK
    #Zip::File.open(tmpfilename) do |z|
    #  zip.each do |z|
    #    puts "+++ #{z.name}"
    #  end
    #end
    package.parts.purge
    package.files.attach(io: File.open(tmpfilename), filename: Time.now.strftime('%Y%m%d%H%M%S') + '.zip')
    File.delete(tmpfilename)
    if package.files.last.checksum == checksum
    # TODO: Update manifest
      #package.manifest = 'test'
      package.save
    else
      # TODO: Block package/user, inform admin
      package.files.last.destroy
    end
  end
end
