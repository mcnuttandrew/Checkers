
require 'colorize'
class Piece
  attr_reader :pos, :color
  
  def initialize(board, pos, color, kinged = false)
    @board = board
    @pos = pos
    @kinged = kinged
    @color = color
  end
  
  def name
    if @kinged
      @color == :red ? "K".red : "K".black
    else
      @color == :red ? "M".red : "M".black
    end
  end
  
  def perform_moves(sequence)
    begin
      raise InvalidMoveError unless valid_move_seq?(sequence)
    rescue InvalidMoveError => e
      puts "Error #{e.message}"
    else 
      perform_moves!(sequence)
    end
  end
  
  def valid_move_seq?(sequence)

    begin
      copy_board = @board.dup
      # puts copy_board[@pos].nil?
      copy_board[@pos.dup].perform_moves!(sequence)
    rescue => e
      # puts e.exception
      # puts e.backtrace
      return false
    end
    return true
  end
  
  def perform_moves!(sequence)
    sequence.each do |el|
      start, target = el
      move_was_valid = false
      if sequence.length == 1 && is_slide?(target)
         move_was_valid = perform_slide(target)
      else
         move_was_valid = perform_jump(target)
      end
      raise InvalidMoveError unless move_was_valid
    end
  end
  
  
  
  #Executive move handeler, only executes moves, does nothing else
  def move!(target)
    @board[@pos] = nil
    @pos = target   
    @board[@pos] = self
    true
  end
  
  def is_slide?(end_pos)
    ((@pos[0] - end_pos[0]).abs == 1) && ((@pos[1] - end_pos[1]).abs == 1)
  end
  
  def perform_slide(target)
    valid_slides.include?(target) ? move!(target) : false
  end
  
  def perform_jump (target)
    if valid_jumps.include?(target) 
       @board[get_flyover(target)].delete!
       move!(target) 
    else
      false
    end
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
    
  #only handles single jumps
  def valid_jumps 
    jumps = []
    move_dirs.each do |jump|
      #landing location
      x, y = (2 * jump[0] + pos[0]), (2 * jump[1] + pos[1])
      #flyover square
      u, v = (jump[0] + pos[0]), (jump[1] + pos[1])
      next unless (0..7).include?(x) && (0..7).include?(y)      
      jumps << [x, y] if (!@board[[u, v]].nil?) && @board[[x, y]].nil?
    end
    jumps
  end
  
  def get_flyover(target)
    [@pos[0] + (target[0] - @pos[0])/2, @pos[1] + (target[1] - @pos[1])/2]
  end
  
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

class InvalidMoveError < StandardError
  
end