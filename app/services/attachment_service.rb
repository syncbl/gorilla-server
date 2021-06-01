class AttachmentService < ApplicationService
  def initialize(source, filename)
    @source = source
    @filename = filename
  end

  def call
    return unless build
    @source.file.attach(
      io: File.open(@filename),
      filename: "#{@source.created_at.strftime("%y%m%d%H%M%S%2L")}.zip",
      content_type: "application/zip",
      identify: false,
    )
    File.delete(@filename) unless File.basename(@filename) == "test.zip"
    if @source.package.size == 0
      @source.package.update(size: @source.unpacked_size)
      @source.is_merged = true
    end
    @source.validated_at = Time.current
    @source.save
  end

  protected

  def build
    @source.unpacked_size = 0
    filelist = {}
    Zip::File.open(@filename) do |zipfile|
      raise I18n.t("errors.attributes.source.packed_files_too_many") if zipfile.size > MAX_FILE_COUNT
      zipfile.each do |z|
        next if z.directory?
        if z.size > MAX_FILE_SIZE
          raise I18n.t("errors.attributes.source.packed_file_too_big", name: z.name, size: z.size)
        end
        filelist[z.name] = Digest::MD5.base64digest(z.get_input_stream.read) # z.crc
        # Replace with HashFileList.add if needed
        @source.unpacked_size += z.size
      end
    end
    @source.filelist = filelist
    @source.file_count = filelist.size
    # TODO: @source.save
  rescue StandardError => e # TODO: Make more specific
    Rails.logger.debug "+++ #{e.class} #{e.message}"
    @source.block! e.message
    false
  end
end
