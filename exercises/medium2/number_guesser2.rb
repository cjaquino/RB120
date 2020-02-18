class GuessingGame
  def initialize(low_range, high_range)
    @guesses = Math.log2(high_range - low_range).to_i + 1
    @low_range = low_range
    @high_range = high_range
    @number = (low_range..high_range).to_a.sample
  end

  def play    
    guess = nil

    puts ""

    loop do
      display_remaining_guesses
      guess = get_guess
      if guess < @number
        puts "Your number is too low.\n\n"
      elsif guess > @number
        puts "Your number is too high.\n\n"
      end
      @guesses -= 1
      break if @guesses == 0 || guess == @number
    end
    if guess == @number
      puts "That's the number!"
      puts "You won!!!"
    elsif @guesses == 0 
      puts "You have no more guesses. You lost!"
      puts "The number was #{@number}"
    end
  end

  def get_guess
    print "Enter a number between #{@low_range} and #{@high_range}: "
    ans = nil
    loop do
      ans = gets.chomp.to_i
      break if (@low_range..@high_range).to_a.include?(ans)
      print "Invalid guess. Enter a number between #{@low_range} and #{@high_range}: "
    end
    ans
  end

  def display_remaining_guesses
    puts "You have #{@guesses} guesses remaining"
  end

  def display_result
    puts "You either won or loat...idk"
  end
end

game = GuessingGame.new(501, 1500)
game.play
game.play