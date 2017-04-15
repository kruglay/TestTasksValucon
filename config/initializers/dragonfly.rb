require 'dragonfly'
require 'dragonfly/s3_data_store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "773f0803c677d52fb7974066f0195be7ec5fa7b1f7fa0d3c90013201891469dd"

  url_format "/media/:job/:name"

  datastore :s3,
    bucket_name: 'test-valucon',
    access_key_id: 'AKIAIJ3BOCHB5TO3FYIQ',
    secret_access_key: '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'
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
