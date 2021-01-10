class ProcessPartsJob < ApplicationJob
  require 'timeout'
  # TODO: Add Timeout stuff

  queue_as :default

  def perform(package, **args)
    checksum = args[:checksum]

    if package.parts.empty? || checksum.empty?
      return false
    end

    source = package.sources.create
    unpacked_size = 0

    if file = ActiveStorage::Blob.find_by(checksum: checksum)
      # TODO: Warn about existing file if it's own or public
    end

    source.update_state "Preparing..."
    tmpfilename = Dir::Tmpname.create(%w[syncbl- .tmp]) {}
    File.open(tmpfilename, 'wb') do |tmpfile|
      package.parts.each do |file|
        file.open { |f| tmpfile.write(File.open(f.path, 'rb').read) }
        file.purge
      end
    end
    filename = Time.now.strftime('%Y%m%d%H%M%S') + '.zip'

    source.update_state "Checking files..."
    if Clamby.virus?(tmpfilename)
      source.block! "+++ VIRUS +++"
      return false
    else
      # TODO: Make sure zip is deleted if fault
      filelist = {}
      Zip::File.open(tmpfilename) do |zipfile|
        zipfile.each do |z|
          if (z.size > MAX_FILE_SIZE)
            source.block! "zip: #{filename}, #{z.name}, #{z.size}"
            break
          end
          filelist.store(z.name, z.crc)
          unpacked_size += z.size
        end
      end
    end
    source.update_state "Attaching..."
    source.file.attach(io: File.open(tmpfilename), filename: filename)
    File.delete(tmpfilename)
    source.generate_manifest(
      files: filelist
    )

    if source.file.checksum == checksum
      source.save
      source.update_state
      package.size += unpacked_size
      package.save
      # TODO: Inform user
    else
      # TODO: Block package/user, inform admin
      source.block! "Checksum error"
    end
  end
end
