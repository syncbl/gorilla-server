class Source < ApplicationRecord
  include Blockable

  belongs_to :package, touch: true

  has_one_attached :file,
                   service: :remote,
                   dependent: :purge_later

  validates :file,
            size: { less_than: MAX_SOURCE_SIZE }
  validates :description,
            length: { maximum: 2048 }
  validates :version,
            length: { maximum: 16 }

  after_create :set_create_status

  def attach(tmpfilename)
    if build(tmpfilename)
      file.attach(
        io: File.open(tmpfilename),
        filename: "#{created_at.strftime("%y%m%d%H%M%S%2L")}.zip",
        content_type: "application/zip"
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

  def flatten_filelist(hash = filelist)
    unless hash.nil? || hash.empty?
      hash.each_with_object({}) do |(k, v), h|
        if v.is_a? Hash
          flatten_filelist(v).map do |h_k, h_v|
            h["#{k}/#{h_k}"] = h_v
          end
        else
          h[k] = v
        end
      end
    end
  end

  private

  def build(tmpfilename)
    root = {}
    Zip::File.open(tmpfilename) do |zipfile|
      zipfile.each do |z|
        next if z.directory?
        if (z.size > MAX_PACKED_FILE_SIZE)
          block! "zip: #{z.name}, #{z.size}"
          # TODO: update_state
          return false
        end
        lvl = root
        path = z.name.split("/")
        filename = path.pop
        path.each { |s| lvl = lvl[s] ||= {} }
        lvl[filename] = z.crc
        self.unpacked_size += z.size
      end
    end
    self.filelist = root
    save
  end

  def set_create_status
    update_state I18n.t("model.source.status_on_create")
  end
end
