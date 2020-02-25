class Grid
  attr_reader :squares

  def initialize(x = 5, y = 5)
    @squares = empty_squares(x, y)
  end

  def empty_squares(x, y)
    s = []
    y.times do |_|
      row = []
      x.times { |_| row << Square.new }
      s << row
    end
    s
  end

  def display
    @squares.each do |row|
      row.each { |square| print square }
      puts ""
    end
  end

  def revive(y, x)
    @squares[y][x].fill
  end

  def kill(coord)
    @squares[y][x].empty
  end

  def toggle(y, x)
    @squares[y][x].toggle
  end
end

class Square
  EMPTY_SIGN = '-'
  FILLED_SIGN = 'X'

  def initialize
    @state = EMPTY_SIGN
  end

  def to_s
    " #{@state} "
  end

  def fill
    @state = FILLED_SIGN
  end

  def empty
    @state = EMPTY_SIGN
  end

  def toggle
    @state = (@state == FILLED_SIGN ? EMPTY_SIGN : FILLED_SIGN)
  end
end

class CGoL
  attr_reader :grid

  def initialize
    @grid = Grid.new
  end

  def play
    3.times do |_|
      clear_screen
      @grid.display
      @grid.toggle(0,0)
      clear_screen
      @grid.display
      @grid.toggle(0,0)
      @grid.toggle(0,1)
      clear_screen
      @grid.display
      @grid.toggle(0,1)
      @grid.toggle(0,2)
      clear_screen
      @grid.display
      @grid.toggle(0,2)
      @grid.toggle(0,3)
      clear_screen
      @grid.display
      @grid.toggle(0,3)
      @grid.toggle(0,4)
    end
  end

  def clear_screen
    sleep(0.1)
    system("clear")
  end
end

game = CGoL.new
game.play
