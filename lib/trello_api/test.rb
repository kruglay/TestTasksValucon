require_relative 'trello_board'
# p File.realpath('../../')
# p TrelloBoard.public_class_method
b = TrelloBoard.new('58ded028055c3564f08ab422')
card = b.create_card!(title: "22sometitle22", description: "somedescription", list_id: "58ded035b5a575cdb375a48b")

p b
p card