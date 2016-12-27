class UploadProcessingWorker
  include Sidekiq::Worker

  def perform(uploader_id)
    # Do something
    ResourceParser.run(uploader_id)
  end
end
