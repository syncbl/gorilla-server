class Source < ApplicationRecord
  include Discard::Model
  include Blockable

  belongs_to :package

  has_one_attached :file,
                   service: :remote,
                   dependent: :purge_later

  validates :file,
            size: { less_than: MAX_FILE_SIZE }
  validates :description,
            length: { maximum: MAX_DESCRIPTION_LENGTH }
  validates :version,
            length: { maximum: MAX_VERSION_LENGTH }

  # TODO: pluck

  default_scope { joins(:file_attachment) }

  scope :published, -> {
    where(Source.arel_table[:published_at].lt(Time.current))
  }

  def attach(filename)
    if build(filename)
      file.attach(
        io: File.open(filename),
        filename: "#{created_at.strftime("%y%m%d%H%M%S%2L")}.zip",
        content_type: "application/zip",
        identify: false
      )
      package.update(size: unpacked_size) if package.size == 0
      package.touch unless package.is_persistent
    end
  end

  def self.merged?
    last&.is_merged.nil? || last.is_merged
  end

  def ready?
    file&.attached?
  end

  private

  def build(tmpfilename)
    filelist = {}
    Zip::File.open(tmpfilename) do |zipfile|
      raise I18n.t('model.source.error.packed_files_too_many') if zipfile.size > MAX_FILE_COUNT
      zipfile.each do |z|
        next if z.directory?
        if z.size > MAX_FILE_SIZE
          raise I18n.t('model.source.error.packed_file_too_big', name: z.name, size: z.size)
        end
        filelist[z.name] = z.crc # Replace with HashFileList.add if needed
        self.unpacked_size += z.size
      end
    end
    self.filelist = filelist
    self.file_count = filelist.size
    save!
  rescue StandardError => e # TODO: Make more specific
    block! e.message
  end
end
