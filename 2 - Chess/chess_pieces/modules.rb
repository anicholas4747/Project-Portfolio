require "byebug"
module Slideable
    
    def horizontal_dirs
        hor_dirs = []
        h_increments = [[0, 1], [0, -1], [1, 0], [-1, 0]]
        h_increments.each do |inc|
            hor_dirs += grow_unblocked_moves_in_dir(inc[0], inc[1])
        end

        hor_dirs
    end
    
    def diagonal_dirs
        diag_dirs = []
        d_increments = [[-1, 1], [-1, -1], [1, 1], [1,-1]]
        d_increments.each do |inc|
            diag_dirs += grow_unblocked_moves_in_dir(inc[0], inc[1])
        end
        
        diag_dirs
    end

    def grow_unblocked_moves_in_dir(x, y)
        # debugger
        res = []
        row, col = pos
        row += x
        col += y

        if (0..7).include?(row) && (0..7).include?(col)
            until !((0..7).include?(row) && (0..7).include?(col)) || (board[[row,col]].color != nil)
                break if !((0..7).include?(row) && (0..7).include?(col))
                res << [row, col]
                row += x
                col += y
            end
        end
        # also add attack positions
        if ((0..7).include?(row) && (0..7).include?(col))
            if board[[row,col]].color != nil
                if board[[row,col]].color != self.color 
                    res << [row, col]
                end
            end
        end

        res
    end
end

module Stepable

    def moves
        increments = move_diffs
        moves = []
        increments.each do |inc|
            new_pos = [pos[0] + inc[0], pos[1] + inc[1]]
            if (0..7).include?(new_pos[0]) && (0..7).include?(new_pos[1])
                unless board[new_pos].color == self.color
                    moves << new_pos
                end
            end
        end
        moves
    end

    private 

    def move_diffs
        raise NotImplementedError
    end
end