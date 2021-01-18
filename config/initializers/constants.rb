NAME_FORMAT = /\A[A-Za-z\d\-\_]*\z/
EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
ENDPOINT_TOKEN_REGEN_RANDOM = 10
MAX_PACKED_FILE_SIZE = 2.gigabytes
MAX_ICON_SIZE = 1.megabyte
MAX_PART_SIZE = 1.gigabyte
MAX_SOURCE_SIZE = 4.gigabytes
MIN_NAME_LENGTH = 3
MAX_NAME_LENGTH = 39
MAX_EMAIL_LENGTH = 105
MAX_PACKAGE_NAME_LENGTH = 100
MAX_PARTS_COUNT = 10
MODEL_CACHE_TIMEOUT = 15.minutes

RESTRICTED_NAMES = %w[
  sign_in
  sign_out
  package
  packages
  user
  users
  endpoint
  endpoints
  setting
  settings
  source
  sources
  storage
  admin
  console
  wp-admin
]
