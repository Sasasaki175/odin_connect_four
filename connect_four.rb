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
    diagonals_descending = [
      create_descending_arr(0, 0),
      create_descending_arr(0, 1),
      create_descending_arr(0, 2),
      create_descending_arr(0, 3),
      create_descending_arr(1, 0),
      create_descending_arr(2, 0)
    ]
    
    diagonals_ascending.each do |diag_asc|
      diag_asc_str = diag_asc.join
      return true if diag_asc_str.include?('oooo') || diag_asc_str.include?('xxxx')
    end

    diagonals_descending.each do |diag_desc|
      diag_desc_str = diag_desc.join
      return true if diag_desc_str.include?('oooo') || diag_desc_str.include?('xxxx')
    end

    false
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

  # pass the row and column of the starting cell of the descending diagonal 
  # and it will return an array of the descending diagonal starting from there 
  def create_descending_arr(row, column)
    descending_arr = []

    while row <= 5 && column <= 6 do
      descending_arr << @board[row][column]
      row += 1
      column += 1
    end

    descending_arr
  end
end