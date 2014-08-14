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
          x = 2*xdir + (shift ? 1 : 0)
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
    raise "Invalid Piece selection" if piece.color != color
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
    @grid.flatten.compact.select{|piece| piece.color == color}
  end
  
  def won?
     get_color(:black).length == 0 || get_color(:red).length == 0
  end
end
#
#
#
#  g = Board.new
# # g.render
# # g.make_move([0,2], [1,3])
# # g.render
# # g.make_move([1,5], [2,4])
# # g.render
# # g.make_move([2,4], [0,2])
# # g.render
#
# g.render
# g[[0,2]].perform_moves([[[0, 2], [1, 3]]])
#
# g.render