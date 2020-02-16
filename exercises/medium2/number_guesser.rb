class GuessingGame
  def play
    @guesses = 7
    @number = (1..100).to_a.sample
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
    end
  end

  def get_guess
    print "Enter a number between 1 and 100: "
    ans = nil
    loop do
      ans = gets.chomp.to_i
      break if (1..100).to_a.include?(ans)
      print "Invalid guess. Enter a number between 1 and 100: "
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

game = GuessingGame.new
game.play
game.play