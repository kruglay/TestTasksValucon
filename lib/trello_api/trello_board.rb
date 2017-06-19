require 'net/http'
require 'json'
require_relative 'trello_conf'
require_relative 'trello_card'

class TrelloBoard
  attr_accessor :id, :name, :desc, :desc_data, :closed, :id_organization, :pinned, :url, :short_url, :prefs

  def initialize(id)
    board_hash = TrelloBoard.find_board(id)

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

  def list_exist?(list_id)
    query_str = TrelloConf.get_query_string(:lists, @id)
    uri       = URI.parse(query_str)
    resp      = Net::HTTP.get_response(uri)

    # check response
    begin
      resp.value
      lists = JSON.parse(resp.body)
      lists.map { |i| i['id'] }.include?(list_id)
    rescue
      raise resp.body
    end
  end

  def create_card!(options = {})
    TrelloCard.create_card!(options) if list_exist?(options[:list_id])
  end

  def lists
    query_str = TrelloConf.get_query_string(:lists, @id)
    uri       = URI.parse(query_str)
    resp      = Net::HTTP.get_response(uri)

    # check response
    begin
      resp.value
      JSON.parse(resp.body)
    rescue
      raise resp.body
    end
  end

  def self.find_board(id)
    query_str = TrelloConf.get_query_string(:board, id)
    uri       = URI.parse(query_str)
    resp      = Net::HTTP.get_response(uri)
    # check response
    begin
      resp.value
      JSON.parse(resp.body)
    rescue
      raise resp.body
    end
  end

  def self.list_boards
    query_str = TrelloConf.get_query_string(:boards)
    uri       = URI.parse(query_str)
    resp      = Net::HTTP.get_response(uri)
    # check response
    begin
      resp.value
      JSON.parse(resp.body)
    rescue
      raise resp.body
    end
  end
end