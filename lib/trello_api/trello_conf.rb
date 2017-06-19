require 'yaml'

module TrelloConf
  URL  = 'https://api.trello.com'
  V    = '1'
  KEYS = YAML.load_file(File.expand_path("~/.trellorc"))
  # return query string depend on type
  def self.get_query_string(type, id = nil)
    case type
    when :boards
      URL + "/#{V}/member/me/boards?" \
            "key=#{KEYS['developer_public_key']}&" \
            "token=#{KEYS['member_token']}"
    when :board
      URL + "/#{V}/boards/#{id}?" \
            "key=#{KEYS['developer_public_key']}&" \
            "token=#{KEYS['member_token']}"
    when :lists
      URL + "/#{V}/boards/#{id+'/' unless id.nil?}lists?" \
            "key=#{KEYS['developer_public_key']}&" \
            "token=#{KEYS['member_token']}"
    when :card
      URL + "/#{V}/cards"
    else
      ''
    end
  end
end
