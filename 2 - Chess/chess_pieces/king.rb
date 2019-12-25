require_relative "modules.rb"
require_relative "piece.rb"

class King < Piece
    include Stepable

    def move_diffs
        [[1, 1], [1, 0], [1, -1], [-1, 0], [-1, -1], [-1, 1], [0, 1], [0, -1]]
    end

    def move_dirs
        moves
    end

end