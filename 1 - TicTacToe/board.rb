class Board
    attr_accessor :grid

    def initialize
        @grid = Array.new(3) {Array.new(3)}

    end

    def [](pos)
        row, col = pos
        @grid[row][col]
    end
    def []=(pos,val)
        row, col = pos
        @grid[row][col] = val
    end

    def valid?(pos)
        row, col = pos
        (0..2).include?(row) && (0..2).include?(col)
    end
    def empty?(pos)
        self[pos].nil?
    end

    def place_mark(pos,mark)
        if valid?(pos) && empty?(pos)
            self[pos] = mark
        else
            raise InvalidMoveError
        end
    end

    def win_row?(mark)
        grid.any? {|row| row.all?{|cell| cell == mark}}
    end
    def win_col?(mark)
        (0..2).each do |col_i|
            column = (0..2).map do |row_i|
                self[[row_i,col_i]]
            end
            return true if column.all?{|cell| cell == mark}
        end
        false
    end
    def win_diag?(mark)
        tl2br = [[0,0],[1,1],[2,2]]
        diag1 = tl2br.map {|pos| self[pos]}

        bl2tr = [[2,0],[1,1],[0,2]]
        diag2 = bl2tr.map {|pos| self[pos]}

        diag1.all? {|cell| cell == mark} || diag2.all? {|cell| cell == mark}
    end
    
    def win?(mark)
        win_row?(mark) || win_col?(mark) || win_diag?(mark)
    end

    def empty_positions?
        grid.flatten.any? {|cell| cell.nil?}
    end
end

class InvalidMoveError < StandardError
    def message
        "That's an invalid move, try again.."
    end
end
