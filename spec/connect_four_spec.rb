require_relative '../connect_four'

describe ConnectFour do
  subject(:game) { described_class.new }

  describe '#start_game' do

  end

  describe '#player_move' do
  end

  describe '#place_token' do
    context 'When there is no token under'
      before do
        game.instance_variable_set(:@board, [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          ['o', 'o', 'o', 'o', nil, nil, nil]
        ])
        game.instance_variable_set(:@turn_player, 'x')
      end

      it 'Put the token to the very bottom'
        expect { game.place_token(5) }.to change { game.instance_variable_get(:@board[5][5]) }.from(nil).to('x')
      end
    end
  end

  describe '#game_over' do
    context 'When a row is complete'
      before do
        allow(game).to receive(:check_row).and_return(true)
      end

      it 'Finishes the game'
        expect(game).to be_game_over
      end
    end

    context 'When win conditions are not met'
      before do
        allow(game).to receive(:check_row).and_return(false)
        allow(game).to receive(:check_column).and_return(false)
        allow(game).to receive(:check_diagonal).and_return(false)
      end

      it 'Does not finish the game'
        expect(game).not_to be_game_over
      end
    end
  end

  describe '#check_row' do
    context 'When the board contains a row with four consecutive oooo' do
      before do
        game.instance_variable_set(:@board, [
          ['o', 'o', 'o', 'o', nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ])
      end

      it 'returns true' do
        expect(game.check_row).to be true
      end
    end

    context 'When the board contains a row with four consecutive xxxx' do
      before do
        game.instance_variable_set(:@board, [
          ['x', 'x', 'x', 'x', nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
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
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
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
          ['o', nil, nil, nil, nil, nil, nil],
          ['o', nil, nil, nil, nil, nil, nil],
          ['o', nil, nil, nil, nil, nil, nil],
          ['o', nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ])
      end

      it 'returns true' do
        expect(game.check_column).to be true
      end
    end

    context 'When the board contains a column with four consecutive xxxx' do
      before do
        game.instance_variable_set(:@board, [
          ['x', nil, nil, nil, nil, nil, nil],
          ['x', nil, nil, nil, nil, nil, nil],
          ['x', nil, nil, nil, nil, nil, nil],
          ['x', nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
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
        ['o', nil, nil, nil, nil, nil, nil],
        ['o', nil, nil, nil, nil, nil, nil],
        ['x', nil, nil, nil, nil, nil, nil],
        ['o', nil, nil, nil, nil, nil, nil],
        ['x', nil, nil, nil, nil, nil, nil],
        ['o', nil, nil, nil, nil, nil, nil]
      ])
    end

    it 'returns true' do
      expect(game.check_column).to be false
    end
  end

  describe '#check_diagonal' do
    context 'When the board contains four consecutive oooo in the diagonal ascending'
      before do
        game.instance_variable_set(:@board, [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, 'o', nil, nil, nil],
          [nil, nil, 'o', nil, nil, nil, nil],
          [nil, 'o', nil, nil, nil, nil, nil],
          ['o', nil, nil, nil, nil, nil, nil]
        ])
      end

      it 'returns true' do
        expect(game.check_diagonal).to be true
      end
    end

    context 'When the board contains four consecutive oooo in the diagonal descending'
      before do
        game.instance_variable_set(:@board, [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          ['o', nil, nil, nil, nil, nil, nil],
          [nil, 'o', nil, nil, nil, nil, nil],
          [nil, nil, 'o', nil, nil, nil, nil],
          [nil, nil, nil, 'o', nil, nil, nil]
        ])
      end

      it 'returns true' do
        expect(game.check_diagonal).to be true
      end
    end

    context 'When the board contains four consecutive xxxx in the diagonal ascending'
      before do
        game.instance_variable_set(:@board, [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, 'x', nil, nil, nil],
          [nil, nil, 'x', nil, nil, nil, nil],
          [nil, 'x', nil, nil, nil, nil, nil],
          ['x', nil, nil, nil, nil, nil, nil]
        ])
      end

      it 'returns true' do
        expect(game.check_diagonal).to be true
      end
    end

    context 'When the board contains four consecutive xxxx in the diagonal descending'
     before do
        game.instance_variable_set(:@board, [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          ['x', nil, nil, nil, nil, nil, nil],
          [nil, 'x', nil, nil, nil, nil, nil],
          [nil, nil, 'x', nil, nil, nil, nil],
          [nil, nil, nil, 'x', nil, nil, nil]
        ])
      end

      it 'returns true' do
        expect(game.check_diagonal).to be true
      end
    end

    context 'When the board does not contain any consecutive oooo or xxxx in both diagonal directions'
      before do
        game.instance_variable_set(:@board, [
          [nil, nil, nil, nil, nil, 'x', nil],
          [nil, nil, nil, nil, 'o', nil, nil],
          [nil, nil, nil, 'o', nil, nil, nil],
          [nil, nil, 'x', nil, nil, nil, nil],
          [nil, 'x', nil, nil, nil, nil, nil],
          ['x', nil, nil, nil, nil, nil, nil]
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
        [nil, nil, nil, 'x', nil, nil, nil],
        [nil, nil, 'x', nil, nil, nil, nil],
        [nil, 'x', nil, 'x', nil, nil, nil],
        ['x', nil, 'x', nil, nil, nil, nil],
        [nil, 'x', nil, nil, nil, nil, nil],
        ['x', nil, nil, nil, nil, nil, nil]
      ])
    end

    it 'returns the correct ascending diagonal starting from (3, 0)' do
      expect(game.create_ascending_arr(3, 0)).to eq(['x', 'x', 'x', 'x'])
    end

    it 'returns the correct ascending diagonal starting from (4, 0)' do
      expect(game.create_ascending_arr(4, 0)).to eq([nil, nil, nil, nil, nil])
    end

    it 'returns the correct ascending diagonal starting from (5, 0)' do
      expect(game.create_ascending_arr(5, 0)).to eq(['x', 'x', 'x', 'x', nil, nil])
    end

    it 'returns the correct ascending diagonal starting from (2, 1)' do
      expect(game.create_ascending_arr(2, 1)).to eq(['x', 'x', 'x'])
    end
  end

  describe '#create_descending_arr' do
    before do
      game.instance_variable_set(:@board, [
        ['x', nil, nil, nil, nil, nil, nil],
        [nil, 'x', nil, nil, nil, nil, nil],
        ['x', nil, 'x', nil, nil, nil, nil],
        [nil, 'x', nil, 'x', nil, nil, nil],
        [nil, nil, 'x', nil, nil, nil, nil],
        [nil, nil, nil, 'x', nil, nil, nil]
      ])
    end

    it 'returns the correct descending diagonal starting from (2, 0)' do
      expect(game.create_descending_arr(2, 0)).to eq(['x', 'x', 'x', 'x'])
    end

    it 'returns the correct ascending diagonal starting from (1, 0)' do
      expect(game.create_descending_arr(1, 0)).to eq([nil, nil, nil, nil, nil])
    end

    it 'returns the correct descending diagonal starting from (0, 0)' do
      expect(game.create_descending_arr(0, 0)).to eq(['x', 'x', 'x', 'x', nil, nil])
    end

    it 'returns the correct descending diagonal starting from (1, 1)' do
      expect(game.create_descending_arr(1, 1)).to eq(['x', 'x', 'x'])
    end
  end
end
