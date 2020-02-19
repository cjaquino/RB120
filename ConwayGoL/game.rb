class Grid
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
end

class CGoL
  def initialize
    @grid = Grid.new
  end

  def play
    @grid.display
  end
end

CGoL.new.play