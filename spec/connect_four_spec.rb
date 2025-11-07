require_relative '../lib/connect_four'

describe ConnectFour do
  subject(:game) { described_class.new }

  # before do
  #   allow($stdin).to receive(:gets).and_return("3\n")
  # end


  describe '#start_game' do
    before do
      allow(game).to receive(:show_board)
      allow(game).to receive(:player_move)
    end

    context 'When somebody wins' do
      before do
        allow(game).to receive(:game_over?).and_return(true)
      end

      it 'Outputs who won' do
        winner = game.instance_variable_get(:@turn_player) 
        expect { game.start_game }.to output("'#{winner}' wins!\n").to_stdout
      end
    end

    context "When it's a draw" do
      before do
        allow(game).to receive(:game_over?).and_return(false)
      end

      it 'Outputs draw message' do
        expect { game.start_game }.to output("It's a draw\n").to_stdout
      end
    end
  end

  describe '#player_move' do
    before do
      allow(game).to receive(:gets).and_return("0", "3")
      allow(game).to receive(:place_token)
      allow(game).to receive(:show_board)
      allow(game).to receive(:game_over?).and_return(false, true)
      allow(game).to receive(:board_full?).and_return(false, false)
    end

    it 'prompts for input until valid and changes the player' do
      expected_output = <<~OUTPUT
        o's turn
        Choose column from 1-7
        Invalid input
        x's turn
        Choose column from 1-7
      OUTPUT

      expect { game.player_move }.to output(expected_output).to_stdout
      expect(game).to have_received(:place_token).at_least(:once).with(2) # input 3 => index 2
      expect(game.instance_variable_get(:@turn_player)).to eq('x')
    end
  end

  describe '#place_token' do
    context 'When there is no token under' do
      before do
        game.instance_variable_set(:@board, [
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          ['o', 'o', 'x', 'o', ' ', ' ', 'x']
        ])
        game.instance_variable_set(:@turn_player, 'x')
      end

      it 'Put the token to the very bottom' do
        expect { game.place_token(5) }.to change { game.instance_variable_get(:@board) }.to([
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          ['o', 'o', 'x', 'o', ' ', 'x', 'x']
        ])
      end
    end

    context 'When there is a token under' do
      before do
        game.instance_variable_set(:@board, [
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          ['o', 'o', 'x', 'o', ' ', ' ', 'x']
        ])
        game.instance_variable_set(:@turn_player, 'x')
      end

      it 'Put the token on top of the token in the bottom' do
        expect { game.place_token(3) }.to change { game.instance_variable_get(:@board) }.to([
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', 'x', ' ', ' ', ' '],
          ['o', 'o', 'x', 'o', ' ', ' ', 'x']
        ])
      end
    end
  end

  describe '#game_over?' do
    context 'When a row is complete' do
      before do
        allow(game).to receive(:check_row).and_return(true)
      end

      it 'Finishes the game' do
        expect(game).to be_game_over
      end
    end

    context 'When win conditions are not met' do
      before do
        allow(game).to receive(:check_row).and_return(false)
        allow(game).to receive(:check_column).and_return(false)
        allow(game).to receive(:check_diagonal).and_return(false)
      end

      it 'Does not finish the game' do
        expect(game).not_to be_game_over
      end
    end
  end

  describe '#check_row' do
    context 'When the board contains a row with four consecutive oooo' do
      before do
        game.instance_variable_set(:@board, [
          ['o', 'o', 'o', 'o', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' ']
        ])
      end

      it 'returns true' do
        expect(game.check_row).to be true
      end
    end

    context 'When the board contains a row with four consecutive xxxx' do
      before do
        game.instance_variable_set(:@board, [
          ['x', 'x', 'x', 'x', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' ']
        ])
      end

      it 'returns true' do
        expect(game.check_row).to be true
      end
    end

    context 'When the board has no rows with four consecutive identical tokens' do
      before do
        game.instance_variable_set(:@board, [
          ['o', 'o', 'o', 'x', 'x', 'x', 'o'],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' ']
        ])
      end

      it 'returns true' do
        expect(game.check_row).to be false
      end
    end
  end

  describe '#check_column' do
    context 'When the board contains a column with four consecutive oooo' do
      before do
        game.instance_variable_set(:@board, [
          ['o', ' ', ' ', ' ', ' ', ' ', ' '],
          ['o', ' ', ' ', ' ', ' ', ' ', ' '],
          ['o', ' ', ' ', ' ', ' ', ' ', ' '],
          ['o', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' ']
        ])
      end

      it 'returns true' do
        expect(game.check_column).to be true
      end
    end

    context 'When the board contains a column with four consecutive xxxx' do
      before do
        game.instance_variable_set(:@board, [
          ['x', ' ', ' ', ' ', ' ', ' ', ' '],
          ['x', ' ', ' ', ' ', ' ', ' ', ' '],
          ['x', ' ', ' ', ' ', ' ', ' ', ' '],
          ['x', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' ']
        ])
      end

      it 'returns true' do
        expect(game.check_column).to be true
      end
    end
  end

  context 'When the board has no columns with four consecutive identical tokens' do
    before do
      game.instance_variable_set(:@board, [
        ['o', ' ', ' ', ' ', ' ', ' ', ' '],
        ['o', ' ', ' ', ' ', ' ', ' ', ' '],
        ['x', ' ', ' ', ' ', ' ', ' ', ' '],
        ['o', ' ', ' ', ' ', ' ', ' ', ' '],
        ['x', ' ', ' ', ' ', ' ', ' ', ' '],
        ['o', ' ', ' ', ' ', ' ', ' ', ' ']
      ])
    end

    it 'returns true' do
      expect(game.check_column).to be false
    end
  end

  describe '#check_diagonal' do
    context 'When the board contains four consecutive oooo in the diagonal ascending' do
      before do
        game.instance_variable_set(:@board, [
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', 'o', ' ', ' ', ' '],
          [' ', ' ', 'o', ' ', ' ', ' ', ' '],
          [' ', 'o', ' ', ' ', ' ', ' ', ' '],
          ['o', ' ', ' ', ' ', ' ', ' ', ' ']
        ])
      end

      it 'returns true' do
        expect(game.check_diagonal).to be true
      end
    end

    context 'When the board contains four consecutive oooo in the diagonal descending' do
      before do
        game.instance_variable_set(:@board, [
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          ['o', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', 'o', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', 'o', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', 'o', ' ', ' ', ' ']
        ])
      end

      it 'returns true' do
        expect(game.check_diagonal).to be true
      end
    end

    context 'When the board contains four consecutive xxxx in the diagonal ascending' do
      before do
        game.instance_variable_set(:@board, [
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', 'x', ' ', ' ', ' '],
          [' ', ' ', 'x', ' ', ' ', ' ', ' '],
          [' ', 'x', ' ', ' ', ' ', ' ', ' '],
          ['x', ' ', ' ', ' ', ' ', ' ', ' ']
        ])
      end

      it 'returns true' do
        expect(game.check_diagonal).to be true
      end
    end

    context 'When the board contains four consecutive xxxx in the diagonal descending' do
     before do
        game.instance_variable_set(:@board, [
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ', ' '],
          ['x', ' ', ' ', ' ', ' ', ' ', ' '],
          [' ', 'x', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', 'x', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', 'x', ' ', ' ', ' ']
        ])
      end

      it 'returns true' do
        expect(game.check_diagonal).to be true
      end
    end

    context 'When the board does not contain any consecutive oooo or xxxx in both diagonal directions' do
      before do
        game.instance_variable_set(:@board, [
          [' ', ' ', ' ', ' ', ' ', 'x', ' '],
          [' ', ' ', ' ', ' ', 'o', ' ', ' '],
          [' ', ' ', ' ', 'o', ' ', ' ', ' '],
          [' ', ' ', 'x', ' ', ' ', ' ', ' '],
          [' ', 'x', ' ', ' ', ' ', ' ', ' '],
          ['x', ' ', ' ', ' ', ' ', ' ', ' ']
        ])
      end

      it 'returns false' do
        expect(game.check_diagonal).to be false
      end
    end
  end

  describe '#create_ascending_arr' do
    before do
      game.instance_variable_set(:@board, [
        [' ', ' ', ' ', 'x', ' ', ' ', ' '],
        [' ', ' ', 'x', ' ', ' ', ' ', ' '],
        [' ', 'x', ' ', 'x', ' ', ' ', ' '],
        ['x', ' ', 'x', ' ', ' ', ' ', ' '],
        [' ', 'x', ' ', ' ', ' ', ' ', ' '],
        ['x', ' ', ' ', ' ', ' ', ' ', ' ']
      ])
    end

    it 'returns the correct ascending diagonal starting from (3, 0)' do
      expect(game.create_ascending_arr(3, 0)).to eq(['x', 'x', 'x', 'x'])
    end

    it 'returns the correct ascending diagonal starting from (4, 0)' do
      expect(game.create_ascending_arr(4, 0)).to eq([' ', ' ', ' ', ' ', ' '])
    end

    it 'returns the correct ascending diagonal starting from (5, 0)' do
      expect(game.create_ascending_arr(5, 0)).to eq(['x', 'x', 'x', 'x', ' ', ' '])
    end

    it 'returns the correct ascending diagonal starting from (2, 1)' do
      expect(game.create_ascending_arr(2, 1)).to eq(['x', 'x', 'x'])
    end
  end

  describe '#create_descending_arr' do
    before do
      game.instance_variable_set(:@board, [
        ['x', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', 'x', ' ', ' ', ' ', ' ', ' '],
        ['x', ' ', 'x', ' ', ' ', ' ', ' '],
        [' ', 'x', ' ', 'x', ' ', ' ', ' '],
        [' ', ' ', 'x', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', 'x', ' ', ' ', ' ']
      ])
    end

    it 'returns the correct descending diagonal starting from (2, 0)' do
      expect(game.create_descending_arr(2, 0)).to eq(['x', 'x', 'x', 'x'])
    end

    it 'returns the correct ascending diagonal starting from (1, 0)' do
      expect(game.create_descending_arr(1, 0)).to eq([' ', ' ', ' ', ' ', ' '])
    end

    it 'returns the correct descending diagonal starting from (0, 0)' do
      expect(game.create_descending_arr(0, 0)).to eq(['x', 'x', 'x', 'x', ' ', ' '])
    end

    it 'returns the correct descending diagonal starting from (1, 1)' do
      expect(game.create_descending_arr(1, 1)).to eq(['x', 'x', 'x', ' ', ' '])
    end
  end

  describe '#board_full?' do
    context 'When the board is full' do
      before do
        game.instance_variable_set(:@board, [
          ['x', 'o', 'x', 'o', 'x', 'o', 'x'],
          ['x', 'o', 'x', 'o', 'x', 'o', 'x'],
          ['x', 'o', 'x', 'o', 'x', 'o', 'x'],
          ['o', 'x', 'o', 'x', 'o', 'x', 'o'],
          ['o', 'x', 'o', 'x', 'o', 'x', 'o'],
          ['o', 'x', 'o', 'x', 'o', 'x', 'o']
        ])
      end

      it 'Returns true' do
        expect(game).to be_board_full
      end
    end

    context 'When the board is not full' do
      before do
        game.instance_variable_set(:@board, [
          ['x', 'o', 'x', 'o', 'x', 'o', ' '],
          ['x', 'o', 'x', 'o', 'x', 'o', 'x'],
          ['x', 'o', 'x', 'o', 'x', 'o', 'x'],
          ['o', 'x', 'o', 'x', 'o', 'x', 'o'],
          ['o', 'x', 'o', 'x', 'o', 'x', 'o'],
          ['o', 'x', 'o', 'x', 'o', 'x', 'o']
        ])
      end

      it 'Returns false' do
        expect(game).not_to be_board_full
      end
    end
  end

  describe '#show_board' do
    before do
      game.instance_variable_set(:@board, [
        ['x', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', 'x', ' ', ' ', ' ', ' ', ' '],
        ['x', ' ', 'x', ' ', ' ', ' ', ' '],
        [' ', 'x', ' ', 'x', ' ', ' ', ' '],
        [' ', ' ', 'x', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', 'x', ' ', ' ', ' ']
      ])
    end

    it 'Shows board replacing ' ' with spaces' do
      board = game.instance_variable_get(:@board)
      board_output = <<~OUTPUT
        -1---2---3---4---5---6---7-
         x |   |   |   |   |   |   
        ---------------------------
           | x |   |   |   |   |   
        ---------------------------
         x |   | x |   |   |   |   
        ---------------------------
           | x |   | x |   |   |   
        ---------------------------
           |   | x |   |   |   |   
        ---------------------------
           |   |   | x |   |   |   
        ---------------------------
      OUTPUT

      expect { game.show_board }.to output(board_output).to_stdout
    end
  end
end
