Clamby.configure({
  check: false,
  daemonize: true,
  config_file: nil,
  error_clamscan_missing: true,
  error_clamscan_client_error: false,
  error_file_missing: true,
  error_file_virus: false,
  fdpass: false,
  output_level: "medium", # one of 'off', 'low', 'medium', 'high'
})
