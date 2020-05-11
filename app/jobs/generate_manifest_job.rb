class GenerateManifestJob < ApplicationJob
  queue_as :default

  def perform(package, full = false)
    package.files.each do |file|
      file.open do |f|
        Zip::File.open(f.path) do |zip| 
          zip.each do |z|
            puts "+++ #{z.name}"
          end
        end
      end
    end
  end
end
