require_relative "piece.rb"
require "singleton"

class NullPiece < Piece

    include Singleton 

    def initialize(color=nil)
        @color = color
    end

end