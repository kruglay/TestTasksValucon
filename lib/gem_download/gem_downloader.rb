require File.expand_path('../../../config/environment', __FILE__)

class GemDownloader
  class << self
    # check gem versions in local data base
    def check_versions(name)
      data = gem_data(name)
      find_files(name, data)
    end

    # return gem data by gem name
    def gem_data(name)
      query_str = File.join(CONFIG[:api_url], name + '.json')
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
        rec = Record.where(name: name, version: ver['number'])
        if rec.blank?
          DownloadGemWorker.perform_async(full_name(name, ver['number']), ver)
        else
          SearchLocalFileWorker.perform_async(File.join(CONFIG[:path], name), ver, rec.sha)
        end
      end
    end

    def download_gem(name, data)
      query_str = File.join(CONFIG[:url], name)
      uri       = URI.parse(query_str)
      resp      = Net::HTTP.get_response(uri)
      begin
        resp.value
      rescue
        raise resp.body
      end

      #check path
      FileUtils.mkdir_p(CONFIG[:path]) unless Dir.exist?(CONFIG[:path])
      # save file
      File.open(File.join(CONFIG[:path], name), 'wb') do |file|
        file.write(resp.body)
      end
      Record.create(
          version:  data['number'].to_s,
          gem_copy: File.join(CONFIG[:path], name),
          sha:      data['sha'],
          name: name
      )
    end
  end
end
