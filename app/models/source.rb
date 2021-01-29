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

  def attach(**args)
    file.attach(args)
  end

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
        path.each do |s|
          lvl[s] ||= {}
          lvl = lvl[s]
        end
        lvl[filename] = z.crc
        self.unpacked_size += z.size
      end
    end
    self.filelist = root
    save
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
end
