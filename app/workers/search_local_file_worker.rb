class SearchLocalFileWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(path, data, rec_sha)
    raise "Local file not found" unless File.exist?(path)
    raise "SHA of version #{data['number']} does not match" if rec_sha == data['sha']
  end
end
