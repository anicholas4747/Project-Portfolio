require_relative "display.rb"
require_relative "computer_player.rb"

class Game
    attr_reader :board, :display, :player1, :player2, :cur_player

    def initialize(board, display, p1, p2)
        @board = board
        @display = display
        @player1 = p1
        @player2 = p2
        @cur_player = @player1
    end

    def switch_players!
        @cur_player == @player1 ? @cur_player = @player2 : @cur_player = @player1
    end

    def get_human_move
        while true
            display.render
            user_move = display.cursor.get_input
            return user_move unless user_move.nil?
        end
    end

    def get_computer_move(comp_player)
        display.render
        comp_player.possible_moves.sample
    end

    def one_move(player)
        if player.class == ComputerPlayer
            move = get_computer_move(player)
            board.place_mark(move,player.mark)
        else
            begin
                move = get_human_move
                board.place_mark(move,player.mark)
            rescue InvalidMoveError => exception
                puts
                puts exception.message
                sleep 1.5
                retry
            end
        end
        display.render
        sleep 1.5
    end

    def play
        while board.empty_positions? && !(board.win?(player1.mark) || board.win?(player2.mark))
            if cur_player.class == ComputerPlayer
                puts "\n\nIt is the computer's turn.."
            else
                puts "\n\nIt is #{cur_player.mark}'s Turn"
            end
            sleep 1.5
            one_move(cur_player)
            switch_players!
        end
        game_over_message
    end
    def game_over_message
        puts 
        if board.win?(player1.mark)
            puts "#{player1.mark} won!"
        elsif board.win?(player2.mark)
            puts "#{player2.mark} won!"
        else
            puts "It's a draw!"
        end
        puts "Thanks for playing!"
    end
end