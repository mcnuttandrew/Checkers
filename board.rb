require_relative 'piece.rb'

class Board
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
          place_piece([2*xdir + (shift ? 1 : 0), ydir + (clr == :red ? 0 : 5 )], clr)
        end
        shift = !shift
      end
    end
  end
  
  def make_move(start, end_pos)
    #debugging code, not valid final work
    if is_slide?(start, end_pos) 
       self[start].perform_slide(end_pos)
    else
       self[start].perform_jump(end_pos)
    end
  end
  
  #detects if a proposed move is a slide or not
  def is_slide?(start, end_pos)
    deltX, deltY = (start[0] - end_pos[0]).abs, (start[1] - end_pos[1]).abs
    deltX == 1 && deltY == 1 
  end
  
  def place_piece(pos, color, place_board = self)
    place_board[pos] = Piece.new(place_board, pos, color)
  end
  
  def render
    p " "
    @grid.reverse.each do |row|
      p row.map{|el| el.nil? ? "_" : el.name}.join(" ")
    end
  end
  
  def [](pos)
    @grid[pos[1]][pos[0]]
  end
  
  def []=(pos, value)
    i, j = pos
    @grid[j][i] = value
  end
  
end



g = Board.new
g.render
g.make_move([0,2], [1,3])
g.render
g.make_move([1,5], [2,4])
g.render
g.make_move([2,4], [0,2])
g.render