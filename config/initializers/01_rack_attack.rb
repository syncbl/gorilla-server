RESTRICTED_PATHS = %w[
  /console
  /wp-admin
  /_ignition/execute-solution
  /web_shell_cmd.gch
  /actuator/health
  /wp/wp-login.php
  /blog/wp-login.php
  /wp-login.php
  /wordpress/wp-login.php
  /srs6/serv/urn:verificationservices
  /ecp/Current/exporttool/microsoft.exchange.ediscovery.exporttool.application
]

RESTRICTED_PATHS_STARTS = %w[
  /Autodiscover/
  /wp-content/
  /index.php
  /vendor/
  /solr/admin/
  /?XDEBUG_SESSION_START
  /.
  /api/
  /mifs/
  /admin/
  /wordpress/
]

class Rack::Attack::Request < ::Rack::Request
  def localhost?
    ip == "127.0.0.1"
  end
end

class Rack::Attack
  def self.block_ip(ip)
    Api::Redis.pool.with { |redis| redis.set("Blocked_IP.#{ip}") }
  end
end

Rack::Attack.blocklisted_response = lambda do |request|
  # Redirect to nginx 444
  [302, { "Location": "/x" }, []]
end

Rack::Attack.throttle("API requests by IP", limit: 5, period: 1) do |request|
  request.ip if request.path.downcase.ends_with?(".json")
end

Rack::Attack.blocklist("Block IP from cache") do |request|
  Api::Redis.pool.with { |redis| redis.get("Blocked_IP.#{request.ip}") }
end

Rack::Attack.blocklist("Malicious scanners") do |request|
  # Requests are blocked if the return value is truthy
  request.path == "/x" || # Because this path is reserved for Nginx blocking
    RESTRICTED_PATHS.include?(request.path.downcase) ||
    RESTRICTED_PATHS_STARTS.any? { |s| request.fullpath.starts_with?(s) }
end
