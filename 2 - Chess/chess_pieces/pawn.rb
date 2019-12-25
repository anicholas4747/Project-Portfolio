require_relative "piece.rb"

class Pawn < Piece 

    def move_dirs
        forward_steps + side_attacks
    end

    private

    def at_start_row?
        if color == :B && pos[0] == 1
            true
        elsif color == :W && pos[0] == 6
            true
        else
            false
        end        
    end

    def forward_dir
        color == :B ? 1 : -1
    end

    def forward_steps
        moves = []
        row, col = pos
        up_one = [(row + forward_dir) , col]
        up_two = [(row + (forward_dir*2)) , col]
        if board[up_one].color == nil
            moves << up_one
            moves << up_two if at_start_row? && board[up_two].color == nil
        end
        moves
    end

    def side_attacks
        attacks = []
        row, col = pos
        top_left = [(row + forward_dir), col + 1]
        top_right = [(row + forward_dir), col - 1]
        if top_left[1].between?(0,7)
            unless board[top_left].color == nil
                attacks << top_left unless board[top_left].color == self.color
            end
        end
        if top_right[1].between?(0,7)
            unless board[top_right].color == nil
                attacks << top_right unless board[top_right].color == self.color
            end
        end
        attacks
    end
end