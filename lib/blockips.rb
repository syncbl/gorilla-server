class Blockips

  RESTRICTED_PATHS = %w[
    /Autodiscover/
    /console
    /wp-content/
    /index.php
    /vendor/
    /api/jsonws/
    /admin
    /solr/admin/
    /?XDEBUG_SESSION_START
  ]

  attr_accessor :path

  def self.valid?(path)
    blocker = Blockips.new
    blocker.path = path
    blocker.check
  end

  def check
    check_multipath && check_path
  end

  private

  def check_multipath
    @path.count('/') <= 1
  end

  def check_path
    RESTRICTED_PATHS.none? { |s| @path.starts_with?(s) }
  end

  # TODO: Update IP black list for nginx and reload

end