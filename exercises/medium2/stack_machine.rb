class InvalidTokenError < StandardError; end

class EmptyStackError < StandardError; end

class Minilang
  VALID_COMMANDS = %w(push add sub mult div mod pop print)

  def initialize(str)
    @commands = str
    @register = 0
    @stack = []
  end

  def eval(param = nil)
    command = format(@commands, param).split
    begin
      valid_command?(command)
    rescue InvalidTokenError => e
      puts e.message
      return nil
    end

    command.each do |c|
      begin
        perform_command(c)
      rescue EmptyStackError => e
        puts e.message
        return nil
      end
    end
    
  end

  private

  def perform_command(c)
    case c.downcase
    when 'push'
      push
    when 'add'
      add
    when 'sub'
      subtract
    when 'mult'
      multiply
    when 'div'
      divide
    when 'mod'
      modulo
    when 'pop'
      pop
    when 'print'
      print_register
    else
      @register = c.to_i
    end
  end

  def valid_command?(commands)
    valids = commands.select { |c| VALID_COMMANDS.include?(c.downcase) || valid_integer?(c) }
    invalids = commands - valids
    raise InvalidTokenError, "Invalid Token: #{invalids[0]}" unless valids == commands
    valids == commands
  end

  def valid_integer?(str)
    str == str.to_i.to_s
  end

  def print_register
    puts @register
  end

  def push
    @stack << @register
  end

  def pop
    raise EmptyStackError, "Empty stack!" if @stack.empty?
    @register = @stack.pop
  end

  def add
    @register += pop
  end

  def subtract
    @register -= pop
  end

  def multiply
    @register *= pop
  end

  def divide
    @register /= pop
  end

  def modulo
    @register %= pop
  end
end

CENTIGRADE_TO_FAHRENHEIT = '5 PUSH %<degrees_c>d PUSH 9 MULT DIV PUSH 32 ADD PRINT'
c_to_f = Minilang.new(CENTIGRADE_TO_FAHRENHEIT)
c_to_f.eval(degrees_c: 100)
c_to_f.eval(degrees_c: 0)
c_to_f.eval(degrees_c: -40)

FAHR_TO_CENT = '9 PUSH 32 PUSH %<degrees_f>d SUB PUSH 5 MULT DIV PRINT'
f_to_c = Minilang.new(FAHR_TO_CENT)
f_to_c.eval(degrees_f: 212)
f_to_c.eval(degrees_f: 32)
f_to_c.eval(degrees_f: -40)


# Minilang.new('PRINT').eval
# # 0

# Minilang.new('5 PUSH 3 MULT PRINT').eval
# # 15

# Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# # 5
# # 3
# # 8

# Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# # 10
# # 5

# Minilang.new('5 PUSH POP POP PRINT').eval
# # Empty stack!

# Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# # 6

# Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# # 12

# Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# # Invalid token: XSUB

# Minilang.new('-3 PUSH 5 SUB PRINT').eval
# # 8

# Minilang.new('6 PUSH').eval
# # (nothing printed; no PRINT commands)


# Minilang.new('6 PUSH').eval