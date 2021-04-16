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

Rack::Attack.blocklisted_response = lambda do |request|
  # Redirect to nginx 444
  [302, {'Location' => '/x'}, []]
end

Rack::Attack.blocklist("Malicious scanners") do |request|
  # Requests are blocked if the return value is truthy
  request.path == "/x" || # Because this path is reserved for Nginx blocking
    RESTRICTED_PATHS.include?(request.path.downcase) ||
    RESTRICTED_PATHS_STARTS.any? { |s| request.fullpath.starts_with?(s) }
end
