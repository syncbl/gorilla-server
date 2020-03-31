class JoinPartsToArchiveJob < ApplicationJob
  queue_as :urgent

  def perform(package)
    tmpfilename = Dir::Tmpname.create(['gp-', '.tmp']) {}
    File.open(tmpfilename, 'wb') do |tmpfile|
      package.parts.each do |file|
        file.open do |f|
          tmpfile.write(File.open(f.path, 'rb').read)
        end
      end
    end
    package.parts.purge
    package.archive.attach(io: File.open(tmpfilename), filename: Time.now.strftime('%Y%m%d%H%M%S') + '.zip')
    File.delete(tmpfilename)
  end
end
