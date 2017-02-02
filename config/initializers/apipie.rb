Apipie.configure do |config|
  config.app_name                = "Parrolabs Chicago Health"
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/apidoc"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
  config.app_info                = "Chicago Health Atlas"
end
