CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:      ENV['S3_KEY'],
    aws_secret_access_key:  ENV['S3_SECRET'],
  }

  # if Rails.env.test? || Rails.env.cucumber?
  #   config.storage    = :file
  #   config.enable_processing  = false
  #   config.root               = "#{Rails.root}/tmp"
  # else
  config.storage = :fog
  # end

  config.cache_dir     = "#{Rails.root}/tmp/uploads"
  config.fog_directory = ENV['S3_BUCKET_NAME']
end
