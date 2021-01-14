class ProcessPartsJob < ApplicationJob
  require 'timeout'
  # TODO: Add Timeout stuff

  queue_as :default

  def perform(package, **args)
    checksum = args[:checksum]

    if package.parts.empty? || checksum.empty?
      return false
    end

    if file = ActiveStorage::Blob.find_by(checksum: checksum)
      # TODO: Warn about existing file if it's own or public
    end

    tmpfilename = Dir::Tmpname.create(%w[syncbl- .tmp]) {}
    File.open(tmpfilename, 'wb') do |tmpfile|
      package.parts.each do |file|
        file.open { |f| tmpfile.write(File.open(f.path, 'rb').read) }
        file.purge
      end
    end
    filename = Time.now.strftime('%Y%m%d%H%M%S') + '.zip'

    # TODO: clamscan
    #if Clamby.virus?(tmpfilename)
    #  source.block! "+++ VIRUS +++"
    #  return false
    #end

    # TODO: Make sure zip is deleted if fault
    source = package.sources.create
    source.update_state "Checking files..."
    if source.build(tmpfilename)
      source.save
      source.update_state "Attaching..."
      source.attach(io: File.open(tmpfilename), filename: filename)
    end

    # TODO: Flatten before delete to save some traffic

    File.delete(tmpfilename)

    if source.file.attached? && (source.file.checksum == checksum)
      package.size += source.unpacked_size
      package.save
      # TODO: Inform user
    else
      # TODO: Block package/user, inform admin
      source.destroy
    end
    source.update_state
  end
end
