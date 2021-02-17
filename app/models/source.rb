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

  after_create :set_create_status

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

  def update_state(state = nil)
    Rails.cache.write("#{Source.name}_state_#{id}", state, expires_in: MODEL_CACHE_TIMEOUT)
  end

  def state
    Rails.cache.read("#{Source.name}_state_#{id}")
  end

  def ready?
    blocked_at.nil? && state.nil? && file.attached?
  end

  def flatfilelist
    HashFileList.flatten(filelist)
  end

  private

  def build(tmpfilename)
    filelist = {}
    Zip::File.open(tmpfilename) do |zipfile|
      zipfile.each do |z|
        next if z.directory?
        if (z.size > MAX_PACKED_FILE_SIZE)
          block! "zip: #{z.name}, #{z.size}"
          # TODO: update_state
          return false
        end
        HashFileList.add(filelist, z.name, z.crc)
        self.unpacked_size += z.size
      end
    end
    self.filelist = filelist
    save
  end

  def set_create_status
    update_state I18n.t("model.source.status_on_create")
  end
end
