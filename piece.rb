

class Piece
  attr_reader :pos, :color
  
  def initialize(board, pos, color, kinged = false)
    @board = board
    @pos = pos
    @kinged = kinged
    @color = color
  end
  
  def name #doesn't handle kinged piece rn
    color == :red ? "R" : "B"
  end
  
  # def perform_moves!(sequence)
 #
 #  end
  
  #overall move handeler, both slide and jump make use of this
  #only executes moves, does nothing else
  def move!(target)
    @board[@pos] = nil
    @pos = target   
    @board[@pos] = self
    true
  end
  
  #on board
  #can't move into other pieces
  def perform_slide(target)
    valid_slides.include?(target) ? move!(target) : false
  end

  def valid_slides
    slides = []
    move_dirs.each do |slide|
      x, y = (slide[0] + pos[0]), (slide[1] + pos[1])
      next unless (0..7).include?(x) && (0..7).include?(y)      
      slides << [x, y] if @board[[x, y]].nil?
    end
    slides
  end
  
  #include a delete method that removes piece from the board, 
  #prolly should be on board
  def perform_jump (target)
    if valid_jumps.include?(target) 
       @board[get_flyover(target)].delete!
       move!(target) 
    else
      false
    end
  end
  #still needs delete handleing
  
  #only handles single jumps
  def valid_jumps 
    jumps = []
    move_dirs.each do |jump|
      #landing location
      x, y = (2 * jump[0] +  pos[0]), (2 * jump[1] +   pos[1])
      #flyover square
      u, v = (jump[0] +  pos[0]), (jump[1] +   pos[1])
      next unless (0..7).include?(x) && (0..7).include?(y)      
      jumps << [x, y] if (!@board[[u, v]].nil?) && @board[[x, y]].nil?
    end
    jumps
  end
  
  #gets the position of the piece thatll get captured via a jump
  def get_flyover(target)
    deltX, deltY = (target[0] - @pos[0])/2, (target[1] - @pos[1])/2
    [pos[0] + deltX, pos[1] + deltY]
  end
  #could refactor, but that might obscure how this works
  
  
  def move_dirs
    if @kinged
      [[-1, 1], [1, 1], [-1, -1], [1, -1]]
    else 
      color == :red ? [[-1, 1], [1, 1]] : [[-1, -1], [1, -1]]
    end
  end
  
  def delete!
    @board[@pos] = nil
    @pos = nil
    #add to captured total?
  end
  
  def maybe_promote
    pos[0] == 7 ? @kinged = true : return
  end
  
end