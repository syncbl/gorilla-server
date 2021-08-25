class MergeSourcesService < ApplicationService
  def initialize(package)
    @package = package
  end

  def call
    return unless @package.sources.size > 1

    @package.sources.each_with_index.reverse_each.map do |src, i|
      break if src.is_merged
      @package.sources.each_with_index.reverse_each.drop(@package.sources.size - i).map do |dst, j|
        next unless src.file.attached? && dst.file.attached?
        diff = dst.files.keys & src.files.keys & src.delete_files
        next if diff.empty?
        dst.file.open do |dstfile|
          Zip::File.open(dstfile, create: false) do |dstzipfile|
            dstzipfile.select { |d| !d.directory? && diff.include?(d.name) }.each do |dstz|
              dstzipfile.remove(dstz)
              dstzipfile.commit
            end
            if dstzipfile.size == 0
              dst.destroy
              # TODO: Notify user about deletion
            end
          end
          AttachmentService.call dst, dstfile
        end
      end
    end

    @package.sources.update_all(is_merged: true)
    @package.recalculate_size!
  end
end
