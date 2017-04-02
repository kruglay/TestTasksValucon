class TrelloBoard
  def initialize(id)
    self.find_board(id)
    @id = id
  end
end