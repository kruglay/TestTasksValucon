require_relative '../../lib/gem_download/gem_downloader'

task :check_gems, [:name] do |task, args|
  GemDownloader.check_versions(args.name)
end
