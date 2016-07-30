class Code
  attr_accessor :pegs
  
    PEGS = {"B" => :blue, "G" => :green, "O" => :orange, "P" => :purple, "R" => :red, "Y" => :yellow }
  #BGOPRY
    
    
    def initialize(pegs)
      @pegs = pegs
    end
  
    def pegs
      @pegs
    end
    
    def self.parse(code)
      arr_code = code.split("")
      parsed_code = []
      arr_code.each do |maybe_valid_pegs|
        if PEGS.has_key?(maybe_valid_pegs.upcase) == false 
          raise "Error"
        else
          parsed_code << maybe_valid_pegs.upcase 
        end 
      end
      Code.new(parsed_code)
    end 
    
    
    def self.random
      arr_code = []
      for peg in 0...4
        arr_code << PEGS.keys.sample
      end 
      Code.new(arr_code)
    end 
  
    def [](arr_index)
      pegs[arr_index]
    end
    
    
    def exact_matches(guess_code)
      matches = 0
      guess_code.pegs.each_with_index do |x,i|
        if guess_code.pegs[i] == @pegs[i]
          matches = matches + 1
        end
      end
      return matches
    end
  
  
  
    def near_matches(guess_code)
      almost_matches = 0
      guess_code.pegs.sort.each_with_index do |x,i|
        if @pegs.sort[i] == x
          almost_matches = almost_matches + 1
        end
      end
      return almost_matches - exact_matches(guess_code) 
    end
    
    def ==(codes_arr)
      return true if codes_arr == @pegs
    end


  
end

class Game
  attr_accessor :secret_code, :random, :pegs
  
  
  def initialize(code = nil)
    if code == nil
      @secret_code = Code.random
    else
      @secret_code = Code.new(code)
    end
  end
  
  def secret_code
    @secret_code
  end
  
  def display_matches(guess_code)
    near = @secret_code.near_matches(guess_code)
    exact = @secret_code.exact_matches(guess_code)
    
    puts "There were #{near} near matches!"
    puts "There were #{exact} exact matches!"
  end 
  

  def get_guess
    puts "Guess the code!" 
    puts "Your choices are B,G,O,P,R,Y"
    puts "Enter it like this: 'ROOR'"

    begin
      Code.parse(gets.chomp)
    rescue
      puts "Error. Choose only valid peg colors"
      retry
    end
  end
  
  def play_game 
    guesses = 0 
    while guesses < 10 
      my_guess = get_guess 
      display_matches(my_guess)
      guesses = guesses + 1 
      puts "You've guessed #{guesses} times!"
      if my_guess == secret_code.pegs 
        puts "You win!"
        break 
      end 
      if guesses == 10 
        puts "You lose!"
      end 
    end 
    
  end 
 
end


if $PROGRAM_NAME == __FILE__
  game = Game.new
  game.play_game 
end






