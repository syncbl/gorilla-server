class AttachmentService < ApplicationService
  def initialize(source, filename)
    @source = source
    @filename = filename
  end

  def call
    if build
      @source.file.attach(
        io: File.open(@filename),
        filename: "#{@source.created_at.strftime("%y%m%d%H%M%S%2L")}.zip",
        content_type: "application/zip",
        identify: false
      )
      File.delete(@filename)
      @source.package.update(size: @source.unpacked_size) if @source.package.size == 0
      @source.package.touch unless @source.package.is_persistent
    end
  end

  protected

  def build
    filelist = {}
    Zip::File.open(@filename) do |zipfile|
      raise I18n.t('model.source.error.packed_files_too_many') if zipfile.size > MAX_FILE_COUNT
      zipfile.each do |z|
        next if z.directory?
        if z.size > MAX_FILE_SIZE
          raise I18n.t('model.source.error.packed_file_too_big', name: z.name, size: z.size)
        end
        filelist[z.name] = Digest::MD5.hexdigest(z.get_input_stream.read) # z.crc
        # Replace with HashFileList.add if needed
        @source.unpacked_size += z.size
      end
    end
    @source.filelist = filelist
    @source.file_count = filelist.size
    @source.save
  rescue StandardError => e # TODO: Make more specific
    puts e.message
    @source.block! e.message
  end
end