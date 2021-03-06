require "byebug"
require_relative "all_pieces.rb"


class Board

    attr_reader :grid, :sentinel

    def initialize
        @sentinel = NullPiece.instance
        @grid = Array.new(8) { Array.new(8, sentinel) }
        self.populate
        @made_moves = []
    end

    def populate
        (0...@grid.length).each do |row|
            (0...8).each do |col|
                if [0, 1, 6, 7].include?(row)
                    place_appropriate_piece(row,col)
                else
                    @grid[row][col] = sentinel
                end    
            end   
        end
    end
    
    # Rooks = [0,0] [0,7] [7,0] [7,7]
    # Knights = [0,1] [0,6] [7,1] [7,6]
    # Bishops = [0,2] [0,5] [7,2] [7,5]
    # Queens = [0,3] [7,3]
    # Kings = [0,4] [7,4]
    # Pawns = ROW 1 & ROW 6
    def place_appropriate_piece(row,col)
        [0,1].include?(row) ? color = :B : color = :W
        case row
        when 1, 6
            @grid[row][col] = Pawn.new(color,self,[row,col])
        else
            case col 
            when 0, 7
                @grid[row][col] = Rook.new(color,self,[row,col])
            when 1, 6
                @grid[row][col] = Knight.new(color,self,[row,col])
            when 2, 5
                @grid[row][col] = Bishop.new(color,self,[row,col])
            when 3
                @grid[row][col] = Queen.new(color,self,[row,col])
            when 4
                @grid[row][col] = King.new(color,self,[row,col])
            end
        end
    end


    def [](pos)
        row, col = pos
        grid[row][col]
    end

    def []=(pos, val)
        row, col = pos
        grid[row][col] = val
    end

    def valid_move?(piece,end_pos)
        row, col = end_pos
        if (0..7).include?(row) && (0..7).include?(col)
            if piece.move_dirs.include?(end_pos)
                return true
            end
        end
        false
    end

    def move_piece(color, start_pos, end_pos)
        if start_pos == end_pos
            raise "PLEASE MAKE A MOVE"
        else
            tile = self[start_pos]
            raise "INVALID STARTING POSITION" if tile.color == nil
            raise "INVALID MOVE" unless valid_move?(tile,end_pos)
            raise "THAT MOVE WILL LEAVE YOUR KING IN CHECK" unless tile.valid_moves.include?(end_pos)

            @made_moves << [color,start_pos,end_pos]
            tile.pos = end_pos
            self[end_pos] = self[start_pos]
            self[start_pos] = NullPiece.instance
        end
    end

    def move_piece!(color, start_pos, end_pos)
        unless start_pos == end_pos
            tile = self[start_pos]
            raise "INVALID STARTING POSITION" if tile.color == nil
            raise "INVALID MOVE" unless valid_move?(tile,end_pos)

            @made_moves << [color,start_pos,end_pos]
            tile.pos = end_pos
            self[end_pos] = self[start_pos]
            self[start_pos] = NullPiece.instance
        end
    end

    def in_check?(color)
        opp = (color == :B ? :W : :B)
        opponent_moves = []

        @grid.each_with_index do |row,r_i|
            row.each_with_index do |cell,c_i|
                if cell.color == opp
                    opponent_moves += cell.move_dirs
                end
            end
        end
        
        opponent_moves.any?{|pos| self[pos].class == King && self[pos].color == color}
    end

    def checkmate?(color)
        my_moves = []

        @grid.each_with_index do |row,r_i|
            row.each_with_index do |cell,c_i|
                if cell.color == color
                    my_moves += cell.valid_moves
                end
            end
        end
        in_check?(color) && my_moves.empty?
    end

    def duplic
        board_copy = Board.new
        @made_moves.each do |move_args|
            board_copy.move_piece(*move_args)
        end
        board_copy
    end

end


if __FILE__ == $PROGRAM_NAME
# NB Here's a four-move sequence to get to checkmate from a starting board for your checkmate testing:

# f2, f3
# e7, e5
# g2, g4
# d8, h4

    test = Board.new
    test.move_piece(:W, [6,5], [5,5])
    test.move_piece(:B, [1,4], [3,4])
    test.move_piece(:W, [6,6], [4,6])
    test.move_piece(:B, [0,3], [4,7])
    p test.in_check?(:W)
    p test.checkmate?(:W)

end
# if __FILE__ == $PROGRAM_NAME
#     system "clear"
#     puts "-" * 50
#     puts
#     test = Board.new
#     test.render
#     puts
#     p test[[6,3]].move_dirs
#     test.move_piece(:W,[6,3],[4,3])
#     puts "-" * 50
#     puts
#     test.render
#     puts
#     p test[[7,3]].move_dirs
#     test.move_piece(:W,[7,3],[5,3])
#     puts "-" * 50
#     puts
#     test.render
#     puts
#     p test[[5,3]].move_dirs
#     test.move_piece(:W,[5,3],[2,0])
#     puts "-" * 50
#     puts
#     test.render
#     puts
#     p test[[2,0]].move_dirs
    
#     puts "-" * 50
#     puts
#     test.render
#     puts
# end

# if __FILE__ == $PROGRAM_NAME
#     system "clear"
#     puts "-" * 50
#     puts
#     test = Display.new(Board.new)
    

# end

# if __FILE__ == $PROGRAM_NAME
#     test = Board.new
#     #test.move_piece(color, start_pos, end_pos)
#     pawn = [1,3]
#     knight = [0,6]
#     king = [0,4]
#     rook = [0,0]
#     bishop = [0,2]
#     queen = [0,3]
    
#     p test[pawn].move_dirs # [2,3] [3,3]
#     p test[knight].move_dirs # [2,0] [2,2]
#     p test[king].move_dirs # []
#     p test[rook].move_dirs # []
#     p test[bishop].move_dirs # []
#     p test[queen].move_dirs # []

#     p "-" * 50

#     # test.move_piece(:B, [3,3], [4,3]) #error
#     # test.move_piece(:B, pawn, [3,5]) #error
#     # test.move_piece(:B, pawn, [2,3]) #good
#     test.move_piece(:B, pawn, [3,3]) #good


# end