class Player
  attr_accessor :move, :name, :score, :move_history

  def initialize
    set_name
    @score = 0
    @move_history = []
  end

  def reset_move_history
    @move_history = []
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def to_s
    @value
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (rock? && other_move.lizard?) ||
      (paper? && other_move.rock?) ||
      (paper? && other_move.spock?) ||
      (scissors? && other_move.paper?) ||
      (scissors? && other_move.lizard?) ||
      (lizard? && other_move.paper?) ||
      (lizard? && other_move.spock?) ||
      (spock? && other_move.scissors?) ||
      (spock? && other_move.rock?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (rock? && other_move.spock?) ||
      (paper? && other_move.scissors?) ||
      (paper? && other_move.lizard?) ||
      (scissors? && other_move.rock?) ||
      (scissors? && other_move.spock?) ||
      (lizard? && other_move.rock?) ||
      (lizard? && other_move.scissors?) ||
      (spock? && other_move.paper?) ||
      (spock? && other_move.lizard?)
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard, or spock:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice"
    end
    self.move = Move.new(choice)
    self.move_history << move
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
    self.move_history << move
  end
end

class RPSGame
  attr_accessor :human, :computer, :winner_history
  attr_reader :winning_score
  def initialize
    @human = Human.new
    @computer = Computer.new
    @winning_score = 3
    @winner_history = []
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Good bye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_round_winner
    if human.move > computer.move
      human.score += 1
      @winner_history << human.name
      puts "#{human.name} won!"
    elsif human.move < computer.move
      computer.score += 1
      @winner_history << computer.name
      puts "#{computer.name} won!"
    else
      @winner_history << 'Tie!'
      puts "It's a tie!"
    end
    puts "Press [Enter] to continue..."
    gets
  end

  def display_game_winner
    if human.score == winning_score
      puts "#{human.name} won the game!"
    else
      puts "#{computer.name} won the game"
    end
  end

  def display_scores
    puts "#{human.name}:#{human.score} \t#{computer.name}:#{computer.score}"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Sorry, must be y or n."
    end
    answer == 'y'
  end

  def reset_game
    human.score = 0
    human.move_history = []
    computer.score = 0
    computer.move_history = []
    winner_history = []
  end

  def display_history
    human_moves = human.move_history
    computer_moves = computer.move_history
    winners = winner_history
    human_moves.each_with_index do |move, i|
      puts "Winner:#{winners[i]}\t#{human.name}:#{move}\t#{computer.name}:#{computer_moves[i]}"
    end
  end

  def play
    display_welcome_message
    loop do
      while human.score < winning_score && computer.score < winning_score
        system("clear")
        display_scores
        human.choose
        computer.choose
        display_moves
        display_round_winner
      end
      system("clear")
      display_game_winner
      display_scores
      display_history
      break unless play_again?
      reset_game
    end
    display_goodbye_message
  end
end

RPSGame.new.play
