require_relative "display.rb"

class HumanPlayer
    attr_reader :color, :display
    def initialize(color,display)
        @color = color
        @display = display
    end

    def make_move
        while true
            display.render
            col = @color == :B ? "BLACK" : "BLUE"
            puts "IT IS #{col}'S TURN"
            pos = display.cursor.get_input
            return pos unless pos.nil?
        end
    end
end