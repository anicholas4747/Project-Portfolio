require_relative "human_player.rb"
require_relative "board.rb"

class ComputerPlayer < HumanPlayer
    attr_reader :board

    def initialize(mark, board)
        super(mark)
        @board = board
    end
    
    def possible_moves
        moves = []
        (0..2).each do |row_i|
            (0..2).each do |col_i|
             moves << [row_i,col_i] if board[[row_i,col_i]].nil?
            end
        end
        moves
    end
    
end