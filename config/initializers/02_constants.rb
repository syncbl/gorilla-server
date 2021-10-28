NAME_FORMAT = /\A[\p{L}\d\-\_\!\(\)\[\]\+\']*\z/
UUID_FORMAT = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
MAX_FILE_COUNT = 100000
MAX_ICON_SIZE = 1.megabyte
MAX_FILE_SIZE = 1.gigabyte
MAX_DESCRIPTION_LENGTH = 2048
MAX_VERSION_LENGTH = 16
MIN_NAME_LENGTH = 2
MAX_NAME_LENGTH = 100
MODEL_CACHE_TIMEOUT = 3.hours # TODO: Increase
JOB_TIMEOUT = 5.minutes
USER_SESSION_TIME = 1.week
ENDPOINT_SESSION_TIME = 1.month
USER_AGENT = "Syncbl Server/Net::HTTP/1.0 https://syncbl.com"
SUBSCRIPTION_PLAN_PERSONAL = 1.gigabyte
SUBSCRIPTION_PLAN_PRO = 10.gigabytes
SUBSCRIPTION_PLAN_BUSINESS = 100.gigabytes
NOTIFICATION_EXPIRES_IN = 3.days

ENDPOINT_NOTIFICATIONS = %w[add_package add_component remove_package]
USER_NOTIFICATIONS = %w[remove_source flash_alert flash_notice]

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
]
