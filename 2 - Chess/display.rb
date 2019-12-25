require "colorize"
require 'colorized_string'
require_relative "cursor.rb"
require_relative "board.rb"
class Display
    attr_reader :board, :cursor
    attr_accessor :show_possible_moves, :piece_to_move
    def initialize(board)
        @cursor = Cursor.new([0,0], board)
        @board = board
        @show_possible_moves = false
        @piece_to_move = nil
    end

    def render
        system "clear"

        if cursor.clicked == false
            @piece_to_move = nil 
        end

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
                if cursor.clicked || show_possible_moves

                    if show_possible_moves && cursor.clicked
                        show_possible_moves = false
                    elsif !show_possible_moves && cursor.clicked
                        show_possible_moves = true
                        @piece_to_move = board[cursor.cursor_pos] if @piece_to_move.nil?
                        
                    end

                    if piece_to_move != nil && piece_to_move.color != nil
                        if piece_to_move.move_dirs.include?([r_i,c_i])
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

                #print cell
                print slot.colorize(:color => act_color, :background => back_color)
            end
            puts
        end

        puts "\n\n"
        puts "- Use the arrow keys to move"
        puts "- Press [return] or [spacebar] to select a position"
        puts "- Press [Q], [esc], or [^+C] to quit"

        # puts "cursor.clicked = #{cursor.clicked}"
        # puts "show_possible_moves = #{show_possible_moves}"
        # puts "piece_to_move = #{piece_to_move.class}"
    end
    
end

if __FILE__ == $PROGRAM_NAME

    test = Display.new(Board.new)
    test.render
     
end