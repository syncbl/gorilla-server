class JoinPartsToFileJob < ApplicationJob
  # TODO: ???
  queue_as :urgent

  # TODO: We are sending :checksum, need to include it in perform to check is checksum = real checksum
  def perform(package)
    tmpfilename = Dir::Tmpname.create(['gp-', '.tmp']) {}
    File.open(tmpfilename, 'wb') do |tmpfile|
      package.parts.each do |file|
        file.open do |f|
          tmpfile.write(File.open(f.path, 'rb').read)
        end
      end
    end
    #Zip::File.open(tmpfilename) do |z|

    #end
    package.parts.purge
    package.files.attach(io: File.open(tmpfilename), filename: Time.now.strftime('%Y%m%d%H%M%S') + '.zip')
    package.manifest = 'test'
    package.save
    File.delete(tmpfilename)
  end
end
