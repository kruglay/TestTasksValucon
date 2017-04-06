require "rails_helper"
require_relative '../lib/trello_api/trello_board'
require_relative '../lib/trello_api/trello_conf'

describe TrelloBoard do
  before :each do
    @body     = File.read(__dir__ + "/fixtures/board.json")
    query_str = TrelloConf.get_query_string(:board, '58ded028055c3564f08ab422')
    stub_request(:get, query_str).to_return(:body => @body, :status => 200, :headers => {})
    @board = TrelloBoard.new('58ded028055c3564f08ab422')
  end

  context '.find_board' do
    it 'return hash' do
      board_h = TrelloBoard.find_board('58ded028055c3564f08ab422')

      expect(board_h).to eq JSON.parse(@body)
    end

    it 'raise exception' do
      query_str = TrelloConf.get_query_string(:board, '123')
      body = File.read(__dir__ + "/fixtures/invalid_id.json")
      stub_request(:get, query_str).to_return(:body => body, :status => 400, :headers => {})
      expect{TrelloBoard.find_board('123')}.to raise_exception(RuntimeError)
    end
  end

  describe '#list_exist' do
    before :each do
      body      = File.read(__dir__ + "/fixtures/lists.json")
      query_str = TrelloConf.get_query_string(:lists, '58ded028055c3564f08ab422')
      stub_request(:get, query_str).to_return(:body => body, :status => 200, :headers => {})
    end

    it 'return true' do
      expect(@board.list_exist?('58ded035b5a575cdb375a48b')).to be_truthy
    end

    it 'return false' do
      expect(@board.list_exist?('123')).to be_falsey
    end
  end

  describe '#create_card' do
    before :each do
      body      = File.read(__dir__ + "/fixtures/lists.json")
      query_str = TrelloConf.get_query_string(:lists, '58ded028055c3564f08ab422')
      stub_request(:get, query_str).to_return(:body => body, :status => 200, :headers => {})

      @body      = File.read(__dir__ + "/fixtures/card.json")
      query_str = TrelloConf.get_query_string(:card)
      stub_request(:post, query_str).to_return(:body => @body, :status => 200, :headers => {})
    end

    it 'create card and return card hash' do
      expect(@board.create_card!(title: "4sometitle4", description: "somedescription",
                                   list_id: "58ded035b5a575cdb375a48b")).to eq JSON.parse(@body)

    end

    it "doesn't create card" do
      expect(@board.create_card!(title: "4sometitle4", description: "somedescription",
                                 list_id: "123")).to be_nil
    end
  end
end