require 'rails_helper'
require_relative '../../lib/gem_download/gem_downloader'

describe GemDownloader do
  it 'return full name of file' do
    expect(GemDownloader.full_name('gem_name', '1')).to eq 'gem_name-1.gem'
  end

  context '.gem_data' do
    it 'return gem hash' do
      name      = 'webinfo'
      body      = File.read(__dir__ + '/fixtures/data.json')
      query_str = GemDownloader::API_URL + name + '.json'
      stub_request(:get, query_str).to_return(body: body, status: 200, headers: {})

      expect(GemDownloader.gem_data(name)).to eq JSON.parse(body)
    end

    it 'raise error' do
      name      = '123'
      query_str = GemDownloader::API_URL + name + '.json'
      stub_request(:get, query_str).to_return(body:   'This rubygem could not be found.',
                                              status: 400, headers: {})

      expect { GemDownloader.gem_data(name) }.to raise_exception(RuntimeError)
    end
  end

  context '.download_gem' do
    before(:each) do
      @name     = 'file-1.gem'
      body      = File.binread(__dir__ + '/fixtures/file-1.gem')
      query_str = GemDownloader::URL + @name
      @data     = { 'number' => 1, 'sha' => '123' }
      stub_request(:get, query_str).to_return(body: body, status: 200, headers: {})
    end

    it 'save gem file' do
      GemDownloader.download_gem(@name, @data)
      expect(File.exist?(GemDownloader::PATH + @name)).to be_truthy

      # delete file after creation
      File.delete(GemDownloader::PATH + @name)
    end

    it 'add record' do
      record = nil
      expect { record = GemDownloader.download_gem(@name, @data) }
          .to change(Record, :count).by(1)
      expect(record.version).to eq '1'
      expect(record.gem_copy).to eq GemDownloader::PATH + @name
      expect(record.sha).to eq '123'
    end
  end

  context '.check_version' do
    it "call's gem_data method and find_files" do
      data = JSON.parse(File.read(__dir__ + '/fixtures/data.json'))
      allow(GemDownloader).to receive(:gem_data).and_return(data)
      allow(GemDownloader).to receive(:find_files).with('webinfo', data)

      GemDownloader.check_versions('webinfo')

      expect(GemDownloader).to have_received(:gem_data)
      expect(GemDownloader).to have_received(:find_files)
    end
  end

  context '.find_files' do
    it 'call SearchLocalFileWorker.perform_async' do
      name = 'file.gem'
      data = [{ 'number' => '1' }]
      sha  = '123'

      Record.create(version: '1', gem_copy: name, sha: sha)

      allow(SearchLocalFileWorker).to receive(:perform_async)
          .with(GemDownloader::PATH + name, data[0], sha)

      GemDownloader.find_files(name, data)

      expect(SearchLocalFileWorker).to have_received(:perform_async)
          .with(GemDownloader::PATH + name, data[0], sha)
    end

    it 'call DownloadGemWorker.perform_async' do
      name   = 'file'
      f_name = GemDownloader.full_name('file', '1')
      data   = [{ 'number' => '1' }]

      allow(DownloadGemWorker).to receive(:perform_async)
          .with(f_name, data[0])

      GemDownloader.find_files(name, data)

      expect(DownloadGemWorker).to have_received(:perform_async)
          .with(f_name, data[0])
    end
  end
end
