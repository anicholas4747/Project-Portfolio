require_relative "display.rb"
require_relative "human_player.rb"

class Game
    attr_reader :board, :display, :player_1, :player_2, :current_player
    def initialize(board, display, player_1, player_2)
        @board = board
        @display = display
        @player_1, @player_2 = player_1, player_2
        @current_player = player_1
    end

    def switch!
        @current_player = @current_player == @player_1 ? @player_2 : @player_1
    end
    
    def attempt_move(start_pos, end_pos)
        if current_player.color == board[start_pos].color
            board.move_piece(board[start_pos].color, start_pos, end_pos)
        else
            raise "YOU CAN ONLY MOVE YOU OWN PIECES"
        end
    end

    def play
        turns = 0
        until board.checkmate?(:B) || board.checkmate?(:W)
            begin
                start_pos = current_player.make_move
                end_pos = current_player.make_move
                self.attempt_move(start_pos, end_pos)
                display.render
            rescue RuntimeError => e
                puts "\nERROR:"
                puts e.message
                if e.message == "PLEASE MAKE A MOVE"
                    sleep 0.75
                else
                    sleep 1.75
                end
                retry
            end

            self.switch!
            turns += 1
            break if turns == 50
        end

        if board.checkmate?(:B)
            puts "\nBLUE WINS!"
        elsif board.checkmate?(:W)
            puts "\nBLACK WINS!"
        elsif turns == 50
            puts "\n50 turns have passed with no winner.."
        end

        puts "THANKS FOR PLAYING!!!"
    end
end

## ##movement & rendering
# if __FILE__ == $PROGRAM_NAME
#     b = Board.new
#     d = Display.new(b)
#     test = Game.new(b,d,"p1","p2","p1")
#     test.play
     
# end

# if __FILE__ == $PROGRAM_NAME
# # NB Here's a four-move sequence to get to checkmate from a starting board for your checkmate testing:

# # f2, f3
# # e7, e5
# # g2, g4
# # d8, h4

#     b = Board.new
#     test = Game.new(b,Display.new(b),"p1","p2","p1")
#     test.board.move_piece(:W, [6,5], [5,5])
#     test.board.move_piece(:B, [1,4], [3,4])
#     test.board.move_piece(:W, [6,6], [4,6])
#     test.board.move_piece(:B, [0,3], [4,7])
#     test.display.render
#     p test.board.in_check?(:W)

# end