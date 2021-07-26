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
        diff = dst.files.keys & src.files.keys & src.delete_files.keys
        next if diff.empty?
        dst.file.open do |dstfile|
          Zip::File.open(dstfile, create: false) do |dstzipfile|
            dstzipfile.select { |d| !d.directory? && diff.include?(d.name) }.each do |dstz|
              dstzipfile.remove(dstz)
              dstzipfile.commit
            end
            #dst.discard if dstzipfile.size == 0
          end
          AttachmentService.call dst, dstfile
        end
      end
    end

    ActiveRecord::Base.transaction do
      @package.sources.update_all(is_merged: true)
      # TODO: Inform about freed space
      old_size = @package.size
      @package.size = 0
      @package.sources.each { |s| @package.size += s.unpacked_size }
      if @package.save
        # TODO: Notify old_size - package.reload.size
      else
        # TODO: Something wrong
      end
    end
  end
end
