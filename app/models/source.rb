class Source < ApplicationRecord
  include Discard::Model
  include Blockable

  belongs_to :package, touch: true

  has_one_attached :file,
                   service: :remote,
                   dependent: :purge_later

  validates :file,
            size: { less_than: MAX_FILE_SIZE }
  validates :description,
            length: { maximum: MAX_DESCRIPTION_LENGTH }
  validates :version,
            length: { maximum: MAX_VERSION_LENGTH }

  default_scope { joins(:file_attachment) }

  def attach(filename)
    if build(filename)
      file.attach(
        io: File.open(filename),
        filename: "#{created_at.strftime("%y%m%d%H%M%S%2L")}.zip",
        content_type: "application/zip",
        identify: false
      )
      self.package.update(size: unpacked_size) if self.package.size == 0
    end
  end

  private

  # TODO: I18n
  def build(tmpfilename)
    filelist = {}
    Zip::File.open(tmpfilename) do |zipfile|
      raise "zip: #{zipfile.size}" if zipfile.size > MAX_PACKED_FILE_COUNT
      zipfile.each do |z|
        next if z.directory?
        raise "zip: #{z.name}, #{z.size}" if z.size > MAX_PACKED_FILE_SIZE
        filelist[z.name] = z.crc # Replace with HashFileList.add if needed
        self.unpacked_size += z.size
      end
    end
    self.filelist = filelist
    save!
  rescue StandardError => e # TODO: Make more specific
    block! e.message
  end
end
