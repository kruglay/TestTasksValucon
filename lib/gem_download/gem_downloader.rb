require File.expand_path('../../../config/environment', __FILE__)

class GemDownloader
  API_URL = 'https://rubygems.org/api/v1/versions/'
  URL     = 'https://rubygems.org/downloads/'
  PATH    = '/home/kruglay/gems/' #write here path to save files

  class << self
    # check gem versions in local data base
    def check_versions(name)
      data = gem_data(name)
      find_files(name, data)
    end

    # return gem data by gem name
    def gem_data(name)
      query_str = API_URL + name + '.json'
      uri       = URI.parse(query_str)
      resp      = Net::HTTP.get_response(uri)
      begin
        resp.value
        JSON.parse(resp.body)
      rescue
        raise resp.body
      end
    end

    # return fullname of gem
    def full_name(name, vers)
      "#{name}-#{vers}.gem"
    end

    # find local gem files
    # and download it if didn't find
    def find_files(name, data)
      data.each do |ver|
        rec = Record.find_by(version: ver['number'])
        if rec.blank?
          DownloadGemWorker.perform_async(full_name(name, ver['number']), ver)
        else
          SearchLocalFileWorker.perform_async(PATH + name, ver, rec.sha)
        end
      end
    end

    def download_gem(name, data)
      query_str = URL + name
      uri       = URI.parse(query_str)
      resp      = Net::HTTP.get_response(uri)
      begin
        resp.value
      rescue
        raise resp.body
      end

      # save file
      File.open(PATH + name, 'wb') do |file|
        file.write(resp.body)
      end
      Record.create(version:  data['number'].to_s,
                    gem_copy: PATH + name,
                    sha:      data['sha'])
    end
  end
end
