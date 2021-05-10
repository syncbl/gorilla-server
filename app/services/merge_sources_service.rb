class MergeSourcesService < ApplicationService
  def initialize(package)
    @package = package
  end

  def call
    return false unless @package.sources.size > 1

    published_at = @package.published_at
    @package.update(published_at: nil)

    @package.sources.each_with_index.reverse_each.map do |src, i|
      @package.sources.each_with_index.reverse_each.drop(@package.sources.size - i).map do |dst, j|
        next unless src.file.attached? && dst.file.attached?
        diff = (dst.filelist.to_a & src.filelist.to_a).to_h
        next if diff.empty?
        dst.file.open do |dstfile|
          Zip::File.open(dstfile, Zip::File::CREATE) do |dstzipfile|
            dstzipfile.select { |d| !d.directory? && diff[d.name].present? }.each do |dstz|
              dstzipfile.remove(dstz)
              dstzipfile.commit
            end
            dst.discard if dstzipfile.size == 0
          end
          AttachmentService.call dst, dstfile
        end
      end
    end

    @package.sources.update_all(is_merged: true)
    # TODO: Inform about freed space
    old_size = @package.size
    @package.size = 0
    @package.sources.each do |s|
      @package.size += s.unpacked_size
    end
    @package.published_at = published_at
    if @package.save
      # TODO: Notify old_size - package.reload.size
    else
      # TODO: Something wrong
    end
  end
end