require 'colorize'
require_relative 'board.rb'
require_relative 'human.rb'
require_relative 'computer.rb'

class Game
  def initialize
    @board = Board.new
    @p1 = HumanPlayer.new(:red)
    @p2 = ComputerPlayer.new(:black)
    @current = @p1
  end
  
  def run
    until @board.won?
      move_seq = @current.play_turn(@board)
      break if move_seq == 'quit'
      good_move = @board.make_moves(move_seq, @current.color)
      @board.get_color(@current.color).each {|piece| piece.maybe_promote }
      @current = (@current == @p1 ? @p2 : @p1) if good_move & !@board.won?
    end
    if @board.won?
      puts "The #{@current.color} player has won!"
    elsif @board.stalemate?
      puts "The game ends in a draw"
    else
      puts "looks like you quit"
    end
  end
  
end