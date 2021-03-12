class MergeSourcesJob < ApplicationJob
  queue_as :default

  def perform(package)
    return false unless package.sources.size > 1
    package.sources.each_with_index.reverse_each.map do |src, i|
      package.sources.each_with_index.reverse_each.drop(package.sources.size - i).map do |dst, j|
        next unless src.file.attached? && dst.file.attached?
        diff = (dst.filelist.to_a & src.filelist.to_a).to_h
        puts diff
        next if diff.size == 0
        dst.file.open do |dstfile|
          Zip::File.open(dstfile, Zip::File::CREATE) do |dstzipfile|
            dstzipfile.each do |dstz|
              next if dstz.directory?
              dstzipfile.remove(dstz.name) unless diff[dstz.name].nil?
            end
          end
          dst.attach(dstfile)
        end
      end
    end

    # TODO: Iterate through sources
    # From last to first -> if file exists in filelist
    # then delete existing old files, then rebuild filelist in every source,
    # then MAY BE create complete filelist for package

    # TODO: Don't show merged sources and don't allow to delete them
    # ! Purge file from source before processing to make it unavailable

    # Set 'merged: true' for processed packages
    # Package.size = Sum(source.unpacked_size)
  end
end
