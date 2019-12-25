require_relative "modules.rb"
require_relative "piece.rb"

class Knight < Piece
    include Stepable

    def move_diffs
        [[1, 2], [2, 1], [-1, 2], [2, -1], [-2, 1], [1, -2], [-1, -2], [-2,-1]]
    end

    def move_dirs
        moves
    end
end