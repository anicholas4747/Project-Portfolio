require_relative "display.rb"

#work on players (human & comp) , taking turns , check  & checkmate
class Game
    attr_reader :board, :display, :player_1, :player_2, :current_player
    def initialize(board, display, player_1, player_2, current_player)
        @board = board
        @display = display
        @player_1, @player_2, @current_player = player_1, player_2, current_player
    end

    def start_spot
        while true
            display.render
            start_pos = display.cursor.get_input
            return start_pos unless start_pos.nil?
        end
    end

    def end_spot
        while true
            display.render
            end_pos = display.cursor.get_input
            return end_pos unless end_pos.nil?
        end
    end
    
    def play
        while true
            begin
                start_pos = start_spot
                end_pos = end_spot
                board.move_piece(:B, start_pos, end_pos)
                display.render
            rescue RuntimeError => e
                puts "\n"
                puts e.message
                sleep 1.5
                retry
            end
        end

    end
end


if __FILE__ == $PROGRAM_NAME
    b = Board.new
    test = Game.new(b,Display.new(b),"p1","p2","p1")
    test.play
     
end