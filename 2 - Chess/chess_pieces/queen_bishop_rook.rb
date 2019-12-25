require_relative "modules.rb"
require_relative "piece.rb"

class Rook < Piece
    include Slideable

    def move_dirs
        self.horizontal_dirs
    end 
end

class Queen < Piece 
    include Slideable

    def move_dirs
        self.horizontal_dirs + self.diagonal_dirs
    end

end

class Bishop < Piece
    include Slideable

    def move_dirs
        self.diagonal_dirs
    end

end