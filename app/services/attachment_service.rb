class AttachmentService < ApplicationService
  def initialize(source, filename)
    @source = source
    @filename = filename
  end

  def call
    # TODO: File.chmod(0644, @filename)
    if Rails.env.production? && Clamby.virus?(@filename)
      @source.block! I18n.t("errors.block_reasons.suspicious_attachment")
      return false
    end
    #ActiveRecord::Base.transaction do
    return unless build
    if @source.files.size == 0
      # TODO: Inform user. He can merge or delete this source, but can't publish.
    end
    @source.file.attach(
      io: File.open(@filename),
      filename: "#{@source.created_at.strftime("%y%m%d%H%M%S%2L")}.zip",
      content_type: "application/zip",
      identify: false,
    )
    @source.is_merged = true if @source.package.sources.size == 1
    @source.save!
    @source.package.recalculate_size!
  ensure
    File.delete(@filename) unless File.basename(@filename).start_with?("test")
  end

  private

  def build
    @source.unpacked_size = 0
    filelist = {}
    existing_files = {}
    @source.package.sources.where(is_merged: true).each do |s|
      existing_files.merge! s.files
    end
    Zip::File.open(@filename) do |zipfile|
      if zipfile.size > MAX_FILE_COUNT
        raise I18n.t("errors.attributes.source.packed_files_too_many")
      end

      zipfile.each do |z|
        next if z.directory?
        if z.size > MAX_FILE_SIZE
          raise I18n.t("errors.attributes.source.packed_file_too_big", name: z.name, size: z.size)
        end
        crc = Digest::MD5.base64digest(z.get_input_stream.read)
        if existing_files[z.name] == crc
          zipfile.remove(z.name)
          zipfile.commit # DEBUG: unless File.basename(@filename).start_with?("test")
        else
          filelist[z.name] = crc # z.crc
          # Replace with HashFileList.add if needed
          @source.unpacked_size += z.size
          if @source.unpacked_size > MAX_FILE_SIZE
            raise I18n.t("errors.attributes.source.packed_files_too_many")
          end
        end
      end
    end
    # TODO: Notify if filelist is empty
    @source.files = filelist
  rescue StandardError => e # TODO: Make more specific
    Rails.logger.debug "+++ #{e.class} #{e.message}"
    @source.block! e.message
    false
  end
end
