NAME_FORMAT = /\A[A-Za-z\d\-\_]*\z/
EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
ENDPOINT_TOKEN_REGEN_RANDOM = 2
MAX_PACKED_FILE_SIZE = 2.gigabytes
MAX_ICON_SIZE = 1.megabyte
MAX_FILE_SIZE = 4.gigabytes
MAX_DESCRIPTION_LENGTH=2048
MAX_VERSION_LENGTH=16
MIN_NAME_LENGTH = 3
MAX_USERNAME_LENGTH = 39
MAX_NAME_LENGTH = 100
MAX_EMAIL_LENGTH = 105
MODEL_CACHE_TIMEOUT = 15.minutes
JOB_TIMEOUT = 5.minutes

RESTRICTED_NAMES = %w[
  x         setting
  sign_in   settings
  sign_out  source
  package   sources
  packages  test
  user      admin
  users     console
  endpoint  wp-admin
  endpoints
]
