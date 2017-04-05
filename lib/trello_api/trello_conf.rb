require 'yaml'

module TrelloConf
  URL = 'https://api.trello.com'
  V = '1'
  KEYS = YAML.load_file('../../.trellorc')
end