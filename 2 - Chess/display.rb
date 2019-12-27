require "colorize"
require 'colorized_string'
require_relative "cursor.rb"
require_relative "board.rb"
class Display
    attr_reader :board, :cursor
    attr_accessor :show_possible_moves, :piece_to_move, :pos_moves
    def initialize(board)
        @cursor = Cursor.new([0,0], board)
        @board = board
        @show_possible_moves = false
        @piece_to_move = nil
        @pos_moves = []
        @at_least_one = false
        @check = false
    end

    def render
        puts "\nLoading..."
        if cursor.clicked == false
            @show_possible_moves = false
            @piece_to_move = nil 
        else
            @piece_to_move = board[cursor.cursor_pos] if @piece_to_move.nil?
            unless @piece_to_move.class == NullPiece
                @pos_moves = piece_to_move.valid_moves unless @show_possible_moves
            end
            @show_possible_moves = true
        end

        @at_least_one = false
        @check = false

        system "clear"
        
        board.grid.each_with_index do |row,r_i|
            row.each_with_index do |tile,c_i|
                #text to display
                if tile.color == nil
                    slot = "   "
                else
                    if tile.is_a?(Rook)
                        slot = " ♜ "
                    elsif tile.is_a?(Knight)
                        slot = " ♞ " 
                    elsif tile.is_a?(Bishop)
                        slot = " ♝ "
                    elsif tile.is_a?(Queen)
                        slot = " ♛ "
                    elsif tile.is_a?(King)
                        slot = " ♚ " 
                    elsif tile.is_a?(Pawn)
                        slot = " ♟ " 
                    end
                end

                #checker board
                (r_i + c_i).even? ? back_color = :white : back_color = :light_black

                # piece color
                tile.color == :B ? act_color = :black : act_color = :cyan

                #color possible moves when cell is selected
                if cursor.clicked
                    if piece_to_move != nil && piece_to_move.color != nil
                        if pos_moves.include?([r_i,c_i])
                            @at_least_one = true
                            back_color = :blue
                            piece_to_move.color == :B ? opp_color = :W : opp_color = :B
                            if board[[r_i,c_i]].color == opp_color
                                back_color = :red
                            end
                        end
                    end
                end
                #cursor color
                if cursor.cursor_pos == [r_i,c_i]
                    back_color = :green
                end

                #king in check
                if board[[r_i,c_i]].class == King && board.in_check?(board[[r_i,c_i]].color)
                    back_color = :red
                    @check = true
                end
                #print cell
                print slot.colorize(:color => act_color, :background => back_color)
            end
            puts
        end
        if cursor.clicked && !@at_least_one
            puts "\nTHIS PIECE HAS NO VALID MOVES"
        end
        if @check
            if board.checkmate?(:B) || board.checkmate?(:W)
                puts "\nCHECKMATE!"
            elsif board.in_check?(:B) || board.in_check?(:W)
                puts "\nCHECK!" 
            end
        end
        
        puts "\n" + ("-"*75)
        puts "- Use the arrow keys to move"
        puts "- Press [return] or [spacebar] to toggle select on a position"
        puts "- Press [Q], [esc], or [^+C] to quit"
        puts ("-"*75)

        # puts "cursor.clicked = #{cursor.clicked}"
        # puts "show_possible_moves = #{show_possible_moves}"
        # puts "piece_to_move = #{piece_to_move.class}"
    end
    
end

if __FILE__ == $PROGRAM_NAME

    test = Display.new(Board.new)
    test.render
     
end