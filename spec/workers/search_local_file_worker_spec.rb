require 'rails_helper'

Sidekiq::Testing.fake!

RSpec.describe SearchLocalFileWorker, type: :worker do
  let(:searcher) { SearchLocalFileWorker.new }
  let(:data) { {'number' => '1', 'sha' => '123'} }

  it 'raise queue size' do
    expect {
      SearchLocalFileWorker.perform_async('name', 'data')
    }.to change(SearchLocalFileWorker.jobs, :count).by(1)
  end

  it "raise error 'Local file not found'" do
    expect {
      searcher.perform('spec/gem_download/fixtures/file.gem', 'data', '123')
    }.to raise_error(RuntimeError, 'Local file not found')
  end

  it "raise error 'SHA of version 1 does not match'" do
    expect {
      searcher.perform('spec/gem_download/fixtures/file-1.gem', data, '12')
    }.to raise_error(RuntimeError, 'SHA of version 1 does not match')
  end

  it "do nothing" do
    expect(searcher.perform('spec/gem_download/fixtures/file-1.gem', data, '123')).to be_nil
  end
end
