require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]

  attr_accessor :squares

  def initialize
    @squares = {}
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
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
  # rubocop:enable Metrics/AbcSize

  def [](key)
    @squares[key]
  end

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
      return s[0] if s.max == s.min && s[0] != Square::INITIAL_MARKER
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
  WINNING_SCORE = 5

  @@human_wins = 0
  @@computer_wins = 0

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_player = select_first_player_marker
  end

  def play
    clear
    display_welcome_message

    loop do
      loop do
        display_board

        loop do
          current_player_moves
          break if board.someone_won? || board.full?
          clear_screen_and_display_board if human_turn?
        end
        display_round_result
        reset_round
        break if @@human_wins == WINNING_SCORE || @@computer_wins == WINNING_SCORE
      end
      display_game_result
      break unless play_again?
      reset_game
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Tic-Tac-Toe!"
    puts "First player to #{WINNING_SCORE} wins!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic-Tac-Toe! Goodbye!"
  end

  def display_board
    puts "You(#{human.marker}):#{@@human_wins} Computer(#{computer.marker}):#{@@computer_wins}"
    puts ""
    board.draw
  end

  def select_first_player_marker
    puts "Who shall go first? (H)uman or (C)omputer?"

    ans = nil
    loop do 
      ans = gets.chomp.downcase
      break if ['human','computer', 'h', 'c'].include?(ans)
      puts "Invalid input. (H)uman or (C)omputer?"
    end

    if ans == 'h' || ans == 'human'
      HUMAN_MARKER
    elsif ans == 'c' || ans == 'computer'
      COMPUTER_MARKER
    end
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def joinor(arr, delim, last_delim)
    if arr.size > 2
      "#{arr[0..-2].join(delim)}, #{last_delim} #{arr[-1]}"
    elsif arr.size == 2
      "#{arr[0]} #{last_delim} #{arr[1]}"
    else
      "#{arr[0]}"
    end
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys,', ', 'or')}): "
    num = nil
    loop do
      num = gets.chomp.to_i
      break if board.unmarked_keys.include?(num)
      puts "Sorry, that's not a valid choice."
    end

    board[num] = human.marker
  end

  def computer_moves
    num = if risky_square(computer.marker)
      risky_square(computer.marker)
    elsif risky_square(human.marker)
      risky_square(human.marker)
    elsif board.squares[5].unmarked?
      5
    else
      board.unmarked_keys.sample
    end

    board[num] = computer.marker
  end

  # return integer position of at risk square
  def risky_square(mrkr)
    Board::WINNING_LINES.each do |line|
      s = board.squares.values_at(*line).map(&:marker)
      return line[s.index(' ')] if s.count(mrkr) == 2 && s.count(Square::INITIAL_MARKER) == 1
    end
    nil
  end

  def display_round_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "You won the round!"
      @@human_wins += 1
    when computer.marker
      puts "Computer won the round!"
      @@computer_wins += 1
    else
      puts "It's a tie!"
    end
    puts ""
    puts "Press [Enter] to play next round..."
    gets
  end

  def display_game_result
    if @@human_wins == WINNING_SCORE
      puts "Congratulations! You won the game!!!"
    else
      puts "Maybe next time..."
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

  def reset_round
    board.reset
    clear
    @current_player = select_first_player_marker
  end

  def reset_game
    @@human_wins = 0
    @@computer_wins = 0
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
