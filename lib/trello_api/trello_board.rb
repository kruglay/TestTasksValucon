class TrelloBoard
  include TrelloConf
  attr_accessor :id, :name, :desc, :desc_data, :closed, :id_organization, :pinned, :url, :short_url, :prefs

  def initialize(id)
    board_hash = self.find_board(id)

    if board_hash.nil?
      raise 'Wrong id'
    end

    @id              = board_hash['id']
    @name            = board_hash['name']
    @desc            = board_hash['desc']
    @desc_data       = board_hash['descData']
    @closed          = board_hash['closed']
    @id_organization = board_hash['idOrganization']
    @pinned          = board_hash['pinned']
    @url             = board_hash['url']
    @short_url       = board_hash['shortUrl']
    @prefs           = board_hash['prefs']
  end

  def self.find_board(id)
    keys      = get_keys
    query_str = "/1/boards/#{id}?key=#{keys['developer_public_key']}&token=#{keys['member_token']}"
    uri_board = URI.parse(URLTRELLO + query_str)
    resp      = Net::HTTP.get(uri_board)

    if resp == 'invalid id'
      nil
    else
      JSON.parse(resp)
    end
  end
end