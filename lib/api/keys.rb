# TODO: Full rewrite
# Cache all keys where allow_api_access is true
# Clear cache if new source added to package with allow_api_access

class Api::Keys
  def initialize
    @keys ||= Set[app_key("files/hqdefault.jpg")]
    @keys << "@user@" if Rails.env.development?
  end

  def find(key)
    @keys.include?(key)
  end

  private

  def app_key(path)
    "#{File.basename(path)}:#{Digest::MD5.file(path).hexdigest}"
  end
end
