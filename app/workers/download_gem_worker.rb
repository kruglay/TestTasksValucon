require_relative '../../lib/gem_download/gem_downloader'

class DownloadGemWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(name, data)
    GemDownloader.download_gem(name, data)
  end
end
