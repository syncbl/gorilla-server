module SourcesHelper
  def write_tmp(file)
    tmpfilename = Dir::Tmpname.create(%w[s- .tmp]) { }
    File.open(tmpfilename, "wb") do |tmpfile|
      tmpfile.write(file.read)
    end
    tmpfilename
  end
end
