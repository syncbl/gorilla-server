class MergeSourcesJob < ApplicationJob
  queue_as :default

  def perform(package)
    # TODO: Mark package as busy
    return false unless package.sources.size > 1
    package.sources.each_with_index.reverse_each.map do |src, i|
      package.sources.each_with_index.reverse_each.drop(package.sources.size - i).map do |dst, j|
        next unless src.file.attached? && dst.file.attached?
        diff = (dst.filelist.to_a & src.filelist.to_a).to_h
        next if diff.size == 0
        dst.file.open do |dstfile|
          Zip::File.open(dstfile, Zip::File::CREATE) do |dstzipfile|
            dstzipfile.each do |dstz|
              next if dstz.directory?
              unless diff[dstz.name].nil?
                dstzipfile.remove(dstz)
                dstzipfile.commit
              end
            end
          end
          dst.attach(dstfile)
        end
      end
      src.update(merged: true)
    end
    # TODO: Inform about freed space
    package.recalculate_size!
  end
end
