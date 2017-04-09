require 'rails_helper'

Sidekiq::Testing.fake!

RSpec.describe DownloadGemWorker, type: :worker do
  it 'raise queue size' do
    expect {
      DownloadGemWorker.perform_async('name', 'data')
    }.to change(DownloadGemWorker.jobs, :count).by(1)
  end

  it 'call GemDownloader.downlod_gem' do
    allow(GemDownloader).to receive(:download_gem).with('name', 'data')

    downloader = DownloadGemWorker.new
    downloader.perform('name', 'data')

    expect(GemDownloader).to have_received(:download_gem).with('name', 'data')
  end
end
