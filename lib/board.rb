# encoding: UTF-8

require_relative 'piece.rb'

class Board
  attr_reader :grid
  
  def initialize(prepopulate = true)
    @grid = Array.new(8){Array.new(8)}
    seed_board if prepopulate
  end
  
  def seed_board
    color_list = [:red,:black]
    shift = false
    color_list.each do |clr|
      3.times do |ydir|
        (0..3).each do |xdir|
          x = 2 * xdir + (shift ? 1 : 0)
          y = ydir + (clr == :red ? 0 : 5 )
          place_piece([x, y], clr)
        end
        shift = !shift
      end
    end
  end
  
  def place_piece(pos, color, place_board = self, kinged = false)
    place_board[pos] = Piece.new(place_board, pos, color, kinged)
  end
  
  def make_moves(sequence, color)
    piece = self[sequence[0][0]] 
    raise "There's no piece there" if piece.nil?
    raise "Invalid Piece selection" if piece.color != color
    found_jumps = find_jumps(color)
    if found_jumps.length != 0 && !found_jumps.include?(sequence[0])
      raise "Must jump a piece if possible"
    end
    piece.perform_moves(sequence)
  rescue Exception => e
    puts e.message
    return false
  end
  
 
  
  def dup
    dupped_board = Board.new(false)
    @grid.flatten.compact.each do |piece|
      place_piece(piece.pos, piece.color, dupped_board, piece.kinged)
    end  
    dupped_board
  end
  
  def [](pos)
    @grid[pos[1]][pos[0]]
  end
  
  def []=(pos, value)
    i, j = pos
    @grid[j][i] = value
  end
  
  def get_color(color)
    @grid.flatten.compact.select{|piece| !piece.nil? && piece.color == color}
  end
  
  def find_jumps(color)
    valid_jumps = []
    pieces_with_jumps = get_color(color).select{|el| !el.valid_jumps.empty?}
    pieces_with_jumps.each do |el|
      el.valid_jumps.each do |move|
        valid_jumps << [el.pos, move]
      end
    end
    valid_jumps
  end
  
  def find_slides(color)
    valid_slides = []
    pieces_with_slides = get_color(color).select{|el| !el.valid_slides.empty?}
    pieces_with_slides.each do |el|
      el.valid_slides.each do |move|
        valid_slides << [el.pos, move]
      end
    end
    valid_slides
  end
  
  def won?
     get_color(:black).length == 0 || get_color(:red).length == 0
  end
  
  def stalemate?
    red_moves = find_jumps(:red) + find_slides(:red)
    black_moves = find_jumps(:black) + find_slides(:black)
    if red_moves.length == 0 || black_moves.length ==0
      true
    else
      false
    end
  end
end
