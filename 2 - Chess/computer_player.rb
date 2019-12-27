require_relative "board.rb"

class ComputerPlayer
    attr_reader :color, :board, :display
    attr_accessor :select_piece, :selected_piece

    def initialize(color,board,display)
        @color = color
        @board = board
        @display = display
        @select_piece = true
        @selected_piece = nil
    end

    def pick_piece
        valid_pieces = []
        board.grid.flatten.select {|piece| piece.color == self.color}.each do |piece|
            if piece.valid_moves.length > 0
                valid_pieces << piece
            end
        end
        @selected_piece = valid_pieces.sample
        @selected_piece.pos
    end

    def move_here
        possible_moves = @selected_piece.valid_moves

        opp_color = @color == :B ? :W : :B

        possible_moves.each do |move|
            if board[move].color == opp_color
                return move
            end
        end
        possible_moves.sample
    end

    def make_move
        display.render
        col = @color == :B ? "BLACK" : "BLUE"
        puts "IT IS #{col}'S TURN"

        puts "\nLoading..."

        if @select_piece
            pos = self.pick_piece
            @select_piece = false
        else
            pos = self.move_here
            @select_piece = true
        end

        display.cursor.cursor_pos = pos
        display.render
        sleep 1
        return pos
    end
end