require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
    puts ""
  end

  # def set_square_at(key, marker)
  #   @squares[key].marker = marker
  # end
  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  # returns winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      s = @squares.values_at(*line).map(&:marker)
      return s[0] if s.max == s.min && 
             s[0] != Square::INITIAL_MARKER
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    @marker == INITIAL_MARKER
  end
end

class Player
  attr_reader :marker

  def initialize((marker))
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  FIRST_TO_MOVE = HUMAN_MARKER

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_player = FIRST_TO_MOVE
  end

  def play
    clear
    display_welcome_message

    loop do
      display_board

      loop do
        current_player_moves
        break if board.someone_won? || board.full?
        clear_screen_and_display_board if human_turn?
      end
      display_result
      break unless play_again?
      reset
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Tic-Tac-Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic-Tac-Toe! Goodbye!"
  end

  def display_board
    puts "You: #{human.marker}. Computer: #{computer.marker}"
    puts ""
    board.draw
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_moves
    puts "Choose a square (#{board.unmarked_keys.join(', ')}): "
    num = nil
    loop do
      num = gets.chomp.to_i
      break if board.unmarked_keys.include?(num)
      puts "Sorry, that's not a valid choice."
    end

    # board.set_square_at(num, human.marker)
    board[num] = human.marker
  end

  def computer_moves
    num = board.unmarked_keys.sample
    # board.set_square_at(num, computer.marker)
    board[num] = computer.marker
  end

  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "You lost sucka!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    ans = nil
    loop do
      puts "Would you like to play again? (y/n)"
      ans = gets.chomp.downcase
      break if %w(y n).include?(ans)
      puts "Sorry, must be y or n"
    end

    ans == 'y'
  end

  def clear
    system('clear')
  end

  def reset
    board.reset
    clear
    @current_player = FIRST_TO_MOVE
  end

  def display_play_again_message
    puts "Let's play again"
    puts ''
  end

  def current_player_moves
    if @current_player == HUMAN_MARKER
      human_moves
      @current_player = COMPUTER_MARKER
    else
      computer_moves
      @current_player = HUMAN_MARKER
    end
  end

  def human_turn?
    @current_player == HUMAN_MARKER
  end
end

game = TTTGame.new
game.play
