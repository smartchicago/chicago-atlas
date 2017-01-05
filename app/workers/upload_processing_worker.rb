class UploadProcessingWorker
  include Sidekiq::Worker
  def perform(uploader_id)
    ResourceParser.run(uploader_id)
  end
end
