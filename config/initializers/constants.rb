NAME_EXCLUSIONS = %w(user users package packages setting settings
  endpoint endpoints source sources)
NAME_FORMAT = /\A[A-Za-z\d\-\_]*\z/
EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
ENDPOINT_TOKEN_REGEN_RANDOM = 10
MAX_PACKAGE_SIZE = 5.gigabytes