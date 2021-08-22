class AttachmentService < ApplicationService
  def initialize(source, filename)
    @source = source
    @filename = filename
  end

  def call
    # TODO: unless Clamby.safe?(file)
    #  source.block! I18n.t("errors.block_reasons.suspicious_attachment")
    #  return false
    #end
    return unless build
    ActiveRecord::Base.transaction do
      @source.file.attach(
        io: File.open(@filename),
        filename: "#{@source.created_at.strftime("%y%m%d%H%M%S%2L")}.zip",
        content_type: "application/zip",
        identify: false,
      )
      File.delete(@filename) unless File.basename(@filename).start_with?("test")
      if @source.package.sources.size == 1
        @source.package.update(size: @source.unpacked_size)
        @source.update(is_merged: true)
      end
      @source.package.generate_filelist!
    end
  end

  protected

  def build
    @source.unpacked_size = 0
    filelist = {}
    Zip::File.open(@filename) do |zipfile|
      if zipfile.size > MAX_FILE_COUNT
        raise I18n.t("errors.attributes.source.packed_files_too_many")
      end
      zipfile.each do |z|
        next if z.directory?
        if z.size > MAX_FILE_SIZE
          raise I18n.t("errors.attributes.source.packed_file_too_big", name: z.name, size: z.size)
        end
        filelist[z.name] = Digest::MD5.base64digest(z.get_input_stream.read) # z.crc
        # Replace with HashFileList.add if needed
        @source.unpacked_size += z.size
        if @source.unpacked_size > MAX_FILE_SIZE
          raise I18n.t("errors.attributes.source.packed_files_too_many")
        end
      end
    end
    @source.files = filelist
    # TODO: @source.save
  rescue StandardError => e # TODO: Make more specific
    Rails.logger.debug "+++ #{e.class} #{e.message}"
    @source.block! e.message
    false
  end
end
