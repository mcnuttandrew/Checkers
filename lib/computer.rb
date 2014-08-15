class ComputerPlayer
  attr_reader :color
  
  BOARD_LETTERS = {
      0 => "A",
      1 => "B",
      2 => "C",
      3 => "D",
      4 => "E",
      5 => "F",
      6 => "G",
      7 => "H"
    }
  
  def initialize(color)
    @color = color
  end
  
  #always jumps if the option is open, otherwise moves a random man
  def play_turn(board)
    jumps = board.find_jumps(@color)
    slides = board.find_slides(@color)
    move = (!jumps.empty?) ? [jumps.sample] : [slides.sample]
    readable_move = make_readable(move)
    puts "Computer plays #{readable_move[0]} to #{readable_move[1]}"
    move
  end
  
  def make_readable(input)
    input[0].map {|el| [BOARD_LETTERS[el[0]], el[1] + 1].join("") }
  end
  
  
end