class Source < ApplicationRecord
  include Blockable

  # We need to sort by created instead of updated because of FlattenSourcesJob
  self.implicit_order_column = :created_at

  belongs_to :package

  has_one_attached :file, dependent: :purge_later

  validates :file,
            size: { less_than: 1.gigabyte }

  def attach(**args)
    file.attach(args)
  end

  # TODO: When generate manifest - mark files to delete or replace!
  def generate_manifest(files = nil)
    self.manifest = {
      files: files
    }
  end

  def build(tmpfilename)
    filelist = {}
    Zip::File.open(tmpfilename) do |zipfile|
      zipfile.each do |z|
        if (z.size > MAX_FILE_SIZE)
          block! "zip: #{z.name}, #{z.size}"
          return false
        end
        filelist.store(z.name, z.crc)
        self.unpacked_size += z.size
      end
    end
    generate_manifest(
      files: filelist
    )
    save
  end

  def update_state(state = nil)
    Rails.cache.write("source_state_#{id}", state, expires_in: MODEL_CACHE_TIMEOUT)
  end

  def state
    Rails.cache.read("source_state_#{id}")
  end

  def active?
    blocked_at.nil? && state.nil? && file.attached?
  end
end
