class MergeSourcesJob < ApplicationJob
  queue_as :default

  def perform(package)
    # TODO: Mark package as busy in session! Marking within db will cause
    # unavailability i.e. after restart
    return false unless package.sources.size > 1
    package.sources.each_with_index.reverse_each.map do |src, i|
      package.sources.each_with_index.reverse_each.drop(package.sources.size - i).map do |dst, j|
        next unless src.file.attached? && dst.file.attached?
        diff = (dst.filelist.to_a & src.filelist.to_a).to_h
        next if diff.empty?
        dst.file.open do |dstfile|
          Zip::File.open(dstfile, Zip::File::CREATE) do |dstzipfile|
            dstzipfile.each do |dstz|
              next if dstz.directory?
              unless diff[dstz.name].nil?
                dstzipfile.remove(dstz)
                dstzipfile.commit
              end
            end
            dst.discard if dstzipfile.size == 0
          end
          dst.attach(dstfile)
        end
      end
    end
    package.sources.update_all(is_merged: true)
    # TODO: Inform about freed space
    old_size = package.size
    package.recalculate_size!
    # Notify old_size - package.reload.size
  end
end
