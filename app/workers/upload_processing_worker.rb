class UploadProcessingWorker
  include Sidekiq::Worker        #Sidekiq Module
  include SidekiqStatus::Worker  #Sidekiq Status Module
  sidekiq_options retry: false

  def perform(uploader_id)
    self.total = 100
    at 0 # starts off at 0%

    ResourceParser.run(uploader_id)
    at 100
  end
end
