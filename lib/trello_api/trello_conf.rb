module TrelloConf
  URL = "https://api.trello.com"
  def get_keys
    YAML.load_file((File.join(Rails.root, '.trellorc')))
  end
end