S3DirectUpload.config do |c|
  c.access_key_id = Rails.application.credentials.aws[:access_key_id] # your access key id
  c.secret_access_key = Rails.application.credentials.aws[:secret_access_key] # your secret access key
  c.bucket = Rails.application.credentials.aws[:bucket] # your bucket name
  c.region = Rails.application.credentials.aws[:region] # region prefix of your bucket url. This is _required_ for the non-default AWS region, eg. "s3-eu-west-1"
  c.url = Rails.application.credentials.aws[:endpoint] # S3 API endpoint (optional), eg. "https://#{c.bucket}.s3.amazonaws.com/"
end
