require 'dragonfly'
require 'dragonfly/s3_data_store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "773f0803c677d52fb7974066f0195be7ec5fa7b1f7fa0d3c90013201891469dd"

  url_format "/media/:job/:name"

  if Rails.env.test?
    datastore :memory
  else
    datastore :s3,
              bucket_name:       ENV['S3_BUCKET_NAME'],
              access_key_id:     ENV['S3_ACCESS_KEY'],
              secret_access_key: ENV['S3_SECRET_KEY']
  end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
