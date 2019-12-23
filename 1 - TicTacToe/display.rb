require "colorize"
require_relative "cursor.rb"
require_relative "board.rb"

class Display
    attr_reader :board, :cursor
    def initialize(board)
        @cursor = Cursor.new([0,0], board)
        @board = board
    end

    def render
        system "clear"
        board.grid.each_with_index do |row, r_i|
            row.each_with_index do |cell,c_i|
                case cell
                when :X
                    slot = " X "
                when :O
                    slot = " O "
                else
                    slot = "   "
                end

                if cursor.cursor_pos == [r_i,c_i]
                    back_color = :green
                else
                    back_color = :black
                end

                print slot.colorize(:color => :white, :background => back_color)
                if c_i < 2
                    print "|".colorize(:color => :white, :background => :black)
                end
            end
            if r_i <  2
                puts "\n---|---|---".colorize(:color => :white, :background => :black)
            end
        end
        puts "\n\n"
        puts "- Use the arrow keys to move"
        puts "- Press [return] or [spacebar] to select a position"
        puts "- Press [Q], [esc], or [^+C] to quit"
    end
end