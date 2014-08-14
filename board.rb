# encoding: UTF-8
require 'colorize'
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
  
  def place_piece(pos, color, place_board = self)
    place_board[pos] = Piece.new(place_board, pos, color)
  end
  
  def make_move(start, end_pos)
    piece = self[start]
    if piece.is_slide?(end_pos) 
       piece.perform_slide(end_pos)
    else
       piece.perform_jump(end_pos)
    end
  end
  
  def dup
    dupped_board = Board.new(false)
    @grid.flatten.compact.each do |piece|
      place_piece(piece.pos, piece.color, dupped_board)
    end  
    dupped_board
  end
  
  def render
    shift = false
    @grid.reverse.each do |row|
      index = (-1)
       xx = row.map do |el| 
        index = index + 1
        if el.nil? 
          ((index + (shift ? 1 : 0)) % 2) == 0 ? "   ".on_light_cyan : "   ".on_green
        else
          if ((index + (shift ? 1 : 0)) % 2) == 0 
            (" " + el.name + " ").on_light_cyan
          else
            (" " + el.name + " ").on_green 
          end
        end 
      end
      puts xx.join("")
      shift = !shift
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
# g.render
# g.make_move([0,2], [1,3])
# g.render
# g.make_move([1,5], [2,4])
# g.render
# g.make_move([2,4], [0,2])
# g.render

g.render
g[[0,2]].perform_moves([[[0, 2], [1, 3]]])
g.render