require 'net/http'
require 'json'
require_relative 'trello_conf'

class TrelloCard
  # options = {:title, :description, :list_id}
  def self.create_card!(options = {})
    params = {
        'key'    => TrelloConf::KEYS['developer_public_key'],
        'token'  => TrelloConf::KEYS['member_token'],
        'desc'   => options[:description],
        'name'   => options[:title],
        'idList' => options[:list_id]
    }

    query_str = TrelloConf.get_query_string(:card)
    uri       = URI.parse(query_str)
    resp      = Net::HTTP.post_form(uri, params)

    # check response
    begin
      resp.value
      JSON.parse(resp.body)
    rescue
      raise resp.body
    end
  end
end
