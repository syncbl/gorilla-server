class MergeSourcesService < ApplicationService
  def initialize(package)
    @package = package
  end

  def call
    return unless @package.sources.size > 1

    @package.sources.each_with_index.reverse_each.map do |src, i|
      break if src.merged?

      # TODO: Only published!
      @package.sources.each_with_index.reverse_each.drop(@package.sources.size - i).map do |dst, _j|
        next unless src.file.attached? && dst.file.attached?

        diff = dst.files.keys & src.files.keys & src.delete_files
        next if diff.empty?

        dst.file.open do |dstfile|
          Zip::File.open(dstfile, create: false) do |dstzipfile|
            dstzipfile.select { |d| !d.directory? && diff.include?(d.name) }.each do |dstz|
              dstzipfile.remove(dstz)
              dstzipfile.commit
              dst.files.delete(dstz.name)
              dst.save
            end
            if dstzipfile.size.zero?
              dst.package.user.notify :remove_source, dst.package
              dst.destroy
            end
          end
          AttachmentService.call dst, dstfile
        end
      end
      src.update(merged: true)
    end

    @package.recalculate_size!
  end
end
