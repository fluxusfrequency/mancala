require 'ruby-processing'

# Dir['./mancala/*.rb'].each do |file|
#   require file
# end

class Mancala < Processing::App

  attr_reader :board, :view, :model, :controller
  attr_accessor :ruler

  def setup
    size 1425, 500
    background 0
    @controller = MancalaController.new(self)
    @board = MancalaBoardView.new(self)
    @view = MancalaGameView.new(self)
    @model = MancalaModel.new(self)
    @ruler = MancalaKalahRules.new(self)
  end

  def draw
    view.invite_move
    board.draw_board
    view.draw_all_beads
  end

  def mouse_pressed
    position = [mouse_x, mouse_y]
    controller.take_pit_if_available(position)
    # ruler.check_and_execute_game_over
  end

end

Mancala.new