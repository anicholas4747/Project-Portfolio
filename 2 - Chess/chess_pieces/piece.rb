require "byebug"
class Piece

    attr_reader :color, :board
    attr_accessor :pos
    def initialize(color, board, pos)
        @color, @board, @pos = color, board, pos
    end

    def valid_moves
        #you can't put yourself in check
        valid = []

        #temp info
        origin_pos = self.pos
        #dup the board 
        board_copy = board.duplic

        move_dirs.each do |move|
            piece_at_end_pos = board[move]
            #move piece on dupped board
            board_copy.move_piece!(self.color,origin_pos,move)
            #in check?
            #add if not in check
            unless board_copy.in_check?(self.color)
                valid << move
            end
            #undo move
            board_copy[origin_pos] = self.class.new(self.color,board_copy,self.pos)
            if piece_at_end_pos.class == NullPiece
                board_copy[move] = NullPiece.instance
            else
                board_copy[move] = piece_at_end_pos.class.new(piece_at_end_pos.color,board_copy,move)
            end
        end
        valid
    end

    def move_dirs
        []
    end

end