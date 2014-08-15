class HumanPlayer
  attr_reader :color
  
  BOARD_LETTERS = {
      "a" => 0,
      "b" => 1,
      "c" => 2,
      "d" => 3,
      "e" => 4,
      "f" => 5,
      "g" => 6,
      "h" => 7
    }
    
  def initialize(color)
    @color = color
  end
  
  def play_turn(board)
    render(board)
    puts "It is the #{@color} player's turn. "
    puts "Enter a move of the form a3,b4 b4,a5 "
    get_player_input 
  end
  
  def render(board)
    shift = false
    p ("  "+ ('A'..'H').to_a.join("  "))
    board.grid.reverse.each_with_index do |row, row_index|
      index = -1
       row_output = row.map do |el| 
        index = index + 1
        el.nil? ? render_empty(index, shift) : render_filled(index, el, shift)         
      end
      puts ("#{8-row_index} " + row_output.join(""))
      shift = !shift
    end
  end
  
  def render_empty(index, shift)
    if ((index + (shift ? 1 : 0)) % 2) == 0 
      "   ".on_light_cyan 
    else   
      "   ".on_green
    end
  end
  
  def render_filled(index, el, shift)
    if ((index + (shift ? 1 : 0)) % 2) == 0 
      (" " + el.name + " ").on_light_cyan
    else
      (" " + el.name + " ").on_green 
    end
  end
  
  def get_player_input
    input = gets.chomp.split(" ")
    validity = input.all?{|el| valid_input?(el)}
    raise "That isn't a valid input." unless validity
    return 'quit' if input.join("") == "quit"
    assemble_sequence(input)
  rescue Exception => e
    puts e.message
    retry
  end
  
  def assemble_sequence(input)
    move_seq = []
    input.each do |sub|
      move = [nil,nil]
      sub.split(",").each_with_index do |el, index|
             place = el.split("")
             place[0] = BOARD_LETTERS[place[0].downcase]
             place[1] = place[1].to_i - 1
             move[index] = place
      end 
      move_seq << move
    end
    move_seq
  end
    
  
  def valid_input?(input)
    input =~ /[A-Ha-h][1-8],[A-Ha-h][1-8]|\Aquit\z/ ? true : false
  end
  
end