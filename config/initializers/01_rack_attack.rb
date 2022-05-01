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
].freeze

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
].freeze

class Rack::Attack::Request < ::Rack::Request
  def localhost?
    ip == "127.0.0.1"
  end
end

Rack::Attack.blocklisted_responder = lambda do |_env|
  # Redirect to nginx 444
  [302, { Location: "/x" }, []]
end

Rack::Attack.throttled_responder = lambda do |env|
  # Name and other data about the matched throttle
  body = [
    env['rack.attack.matched'],
    env['rack.attack.match_type'],
    env['rack.attack.match_data']
  ].inspect

  # Using 503 because it may make attacker think that they have successfully
  # DOSed the site. Rack::Attack returns 429 for throttling by default
  # [ 503, {}, [body]]
end

Rack::Attack.throttle("API requests by IP", limit: 100, period: 1.minute) do |request|
  request.ip if request.path.downcase.ends_with?(".json")
end

Rack::Attack.blocklist("Malicious scanners") do |request|
  # Requests are blocked if the return value is truthy
  Rack::Attack::Fail2Ban.filter("scanners-#{request.ip}",
                                maxretry: 2,
                                findtime: 10.minutes,
                                bantime: 1440.minutes) do
    request.path == "/x" || # Because this path is reserved for Nginx blocking
      RESTRICTED_PATHS.include?(request.path.downcase) ||
      RESTRICTED_PATHS_STARTS.any? { |s| request.fullpath.starts_with?(s) }
  end
end
