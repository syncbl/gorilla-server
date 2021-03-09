class Source < ApplicationRecord
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
      )
    end
  end

  def flatfilelist
    HashFileList.flatten(filelist)
  end

  private

  def build(tmpfilename)
    filelist = {}
    Zip::File.open(tmpfilename) do |zipfile|
      # TODO: Count files and unpacked sizes and store in source to show
      zipfile.each do |z|
        next if z.directory?
        if (z.size > MAX_PACKED_FILE_SIZE)
          block! "zip: #{z.name}, #{z.size}"
          return false
        end
        HashFileList.add(filelist, z.name, z.crc)
        self.unpacked_size += z.size
      end
    end
    self.filelist = filelist
    save
  rescue StandardError => e # TODO: Make more specific
    block! e.message
  end
end
