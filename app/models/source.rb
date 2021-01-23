class Source < ApplicationRecord
  include Blockable

  belongs_to :package

  has_one_attached :file,
                   service: :remote,
                   dependent: :purge_later

  validates :file,
            size: { less_than: MAX_SOURCE_SIZE }

  def attach(**args)
    file.attach(args)
  end

  def build(tmpfilename)
    filelist = {}
    Zip::File.open(tmpfilename) do |zipfile|
      zipfile.each do |z|
        if (z.size > MAX_PACKED_FILE_SIZE)
          block! "zip: #{z.name}, #{z.size}"
          # TODO: update_state
          return false
        end
        filelist.store(z.name, z.crc)
        self.unpacked_size += z.size
      end
    end
    self.filelist = filelist
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
