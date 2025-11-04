class ConnectFour
  def start_game
  end

  def player_move
  end

  def game_over?
    check_row || check_column || check_diagonal
  end

  def check_row
    @board.each do |row|
      return true if row.join.include?('oooo') || row.join.include?('xxxx')
    end

    false
  end

  def check_column
    @board.transpose.each do |column|
      return true if column.join.include?('oooo') || column.join.include?('xxxx')
    end

    false
  end

  def check_diagonal
    diagonals_ascending = [
      create_ascending_arr(3, 0),
      create_ascending_arr(4, 0),
      create_ascending_arr(5, 0),
      create_ascending_arr(5, 1),
      create_ascending_arr(5, 2),
      create_ascending_arr(5, 3)
    ]
    diagonals_descending = []
    
    diagonals_ascending.each do |diag_asc|
      return true if diag_asc.join.include?('oooo') || diag_asc.join.include?('xxxx')
    end

  end

  # pass the row and column of the starting cell of the ascending diagonal
  # and it will return an array of the ascending diagonal starting from there 
  def create_ascending_arr(row, column)
    ascending_arr = []

    while row >= 0 && column <= 6 do
      ascending_arr << @board[row][column]
      row -= 1
      column += 1
    end

    ascending_arr
  end
end