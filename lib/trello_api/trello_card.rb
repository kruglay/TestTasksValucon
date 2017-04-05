require 'net/http'
require 'json'
require_relative 'trello_conf'

class TrelloCard
  attr_accessor :id, :badges, :check_item_states, :closed, :date_last_activity, :desc, :desc_data, :due, :due_complete, :email,
                :id_board, :id_check_lists, :id_labels, :id_list, :id_members, :id_short, :id_attachment_cover,
                :manual_cover_attachment, :labels, :name, :pos, :short_url, :url

  def initialize(options = {})
    list_id = options[:list_id]
    raise 'Options must have :list_id' if list_id.nil? || list_id == ""

    card_h = TrelloCard.create_card!(options)

    @id                      = card_h['id']
    @badges                  = card_h['badges']
    @check_item_states       = card_h["checkItemStates"]
    @closed                  = card_h["closed"]
    @date_last_activity      = card_h["dateLastActivity"]
    @desc                    = card_h["desc"]
    @desc_data               = card_h["descData"]
    @due                     = card_h["due"]
    @due_complete            = card_h["dueComplete"]
    @email                   = card_h["email"]
    @id_board                = card_h["idBoard"]
    @id_check_lists          = card_h["idChecklists"]
    @id_labels               = card_h["idLabels"]
    @list_id                 = card_h["idList"]
    @id_members              = card_h["idMembers"]
    @id_short                = card_h["idShort"]
    @id_attachment_cover     = card_h["idAttachmentCover"]
    @manual_cover_attachment = card_h["manualCoverAttachment"]
    @labels                  = card_h["labels"]
    @name                    = card_h["name"]
    @pos                     = card_h["pos"]
    @short_url               = card_h["shortUrl"]
    @url                     = card_h["url"]
  end

  # options = {:title, :description, :list_id}
  def self.create_card!(options = {})
    keys   = TrelloConf::KEYS
    params = {
        'key'    => keys['developer_public_key'],
        'token'  => keys['member_token'],
        'desc'   => options[:description],
        'name'   => options[:title],
        'idList' => options[:list_id]
    }
    options.merge(params)

    query_str = "/#{TrelloConf::V}/cards"
    uri       = URI.parse(TrelloConf::URL + query_str)
    resp      = Net::HTTP.post_form(uri, params)

    #check response
    begin
      resp.value
      JSON.parse(resp.body)
    rescue
      raise resp.body
    end
  end

end