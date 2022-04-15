# TODO: Full rewrite
# Cache all keys where package_type: :trusted is true
# Clear cache if new source added to package with package_type: :trusted

class Api::Keys
  def initialize
    # TODO: Load and cache keys from Packages by name, delete previous
    @keys = Set[] # Set[app_key("files/hqdefault.jpg")]
  end

  def find(key)
    Rails.env.development? || @keys.include?(key)
  end

  private

  def app_key(path)
    "#{File.basename(path)}:#{Digest::SHA256.file(path).hexdigest}"
  end
end
