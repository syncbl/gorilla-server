NAME_FORMAT = /\A[\p{L}\d\-_!()\[\]+']*\z/
UUID_FORMAT = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
RESTRICTED_PATH_CHARACTERS = %w[: % | < > ? *].freeze
ROOT_ENUMERATOR = %i[default_storage local_app_data local_app_data_low program_files_x64
                     program_files_x86 roaming_app_data system_root main_app_dir].freeze
MAX_FILE_COUNT = 100_000
MAX_ICON_SIZE = 1.megabyte
MAX_FILE_SIZE = 1.gigabyte
MAX_SHORT_DESCRIPTION_LENGTH = 400
MAX_DESCRIPTION_LENGTH = 10_000
MAX_VERSION_LENGTH = 16
MIN_NAME_LENGTH = 2
MAX_NAME_LENGTH = 100
JOB_TIMEOUT = 5.minutes
USER_SESSION_TIME = 1.week
ENDPOINT_SESSION_TIME = 1.month
# USER_AGENT = "Syncbl Server/Net::HTTP/1.0 https://syncbl.com"
PLAN_PERSONAL = 1.gigabyte
PLAN_PRO = 10.gigabytes
PLAN_BUSINESS = 100.gigabytes
NOTIFICATION_EXPIRES_IN = 3.days
TOKEN_RESET_THRESHOLD = 1.day

ENDPOINT_NOTIFICATIONS = %w[add_package add_component remove_package].freeze
USER_NOTIFICATIONS = %w[remove_source].freeze

RESTRICTED_NAMES = %w[
  setting sign_in api
  settings sign_out actuator
  page file
  pages files
  source test
  sources admin
  package console
  packages wp-admin
  user _ignition
  users autodiscover
  endpoint mifs
  endpoints vendor
].freeze
