module TicTacLogic
  EMPTY_CELL = "[ ]"
  X_CELL = "[X]"
  O_CELL = "[O]"

  def newBoard
    board = {}
    9.times do |i|
      board[i + 1] = EMPTY_CELL
    end
    board
  end

  def showBoard
    p "#{self.board[1]}#{self.board[2]}#{self.board[3]}"
    p "#{self.board[4]}#{self.board[5]}#{self.board[6]}"
    p "#{self.board[7]}#{self.board[8]}#{self.board[9]}"
  end

  def turnPrioriy
    result = ''
    until result == 'X' || result == 'O' do
      p "New game! Who goes first? X or O?"
      result = gets.chomp.upcase
    end
    p "#{result}'s' will go first"
    p "enter [game].play to begin!"
    result
  end

  def getMove
    result = gets.chomp.to_i
    if result.between?(1,9)
      return result
    else
      p 'Error. Please enter 1-9 to make your move.'
      self.getMove
    end
  end

  WINS = [[1, 4, 7], [2, 5, 8], [3, 6, 9],
          [1, 2, 3], [4, 5, 6], [7, 8, 9],
          [1, 5, 9], [7, 5, 3]
  ]
end


class TicTacGame 
  include TicTacLogic
  
  attr_reader :board, :turn, :score
  
  def initialize
    @board = self.newBoard
    @turns = 0
    @turn = turnPrioriy
    @score = {'X' => 0, 'O' => 0}
  end

  def play
    p "#{@turn}'s turn. Enter 1-9 to make your move"
    self.showBoard
    move(@turn, self.getMove)
  end

  private
  def move(player, cell)
    if @board[cell] != EMPTY_CELL
      p "That cell is not empty!"
      play
    end
    if player == 'X'
      @board[cell] = X_CELL
      @turn = 'O'
      self.showBoard
    else
      @board[cell] = O_CELL
      @turn = 'X'
      self.showBoard
    end
    check_win
  end

  def check_win
    WINS.each do |group|
      slice = []
      
      group.each_with_index do |val, idx|
        slice << @board[val]
      end

      if slice.uniq.one? && slice.include?('[X]')
        win('X')
      elsif slice.uniq.one? && slice.include?('[O]')
        win('O')
      end
    end
    unless @board.values.any?(EMPTY_CELL)
      win('draw')
    end
    play
  end

  def win(winner)
    if winner == 'draw'
      p "This round ends in a draw!"
    else
      @score[winner] += 1
      p "#{winner} wins the round! The scores are now:"
      p score
    end

    sleep 1
    @board = newBoard
    p "Would you like to play another round? [y/n]"
    playAgain(gets.chomp.upcase)
  end

  def playAgain(answer)
    answer == 'Y' ? self.play : endGame
  end

  def endGame
    if @score['X'] > @score['O']
      p "X wins the game!"
      p score

    elsif @score['X'] == @score['O']
      p "The game is a tie!"
      p score
    else  
      p "O wins the game!"
      p score
    end
    exit
  end

end

x = TicTacGame.new
x.play