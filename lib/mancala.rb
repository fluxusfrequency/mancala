require 'ruby-processing'

Dir['./mancala/*.rb'].each do |file|
  require file
end

class Mancala < Processing::App

  attr_reader :board, :view, :model, :controller
  attr_accessor :ruler

  def setup
    size 1425, 500
    background 0
    @board = MancalaBoardView.new(self)
    @view = MancalaGameView.new(self)
    @model = MancalaModel.new(self)
    @ruler = MancalaKalahRules.new(self)
    @controller = MancalaController.new(self)
  end

  def draw
    board.draw_board
    view.draw_all_beads
    view.invite_move
  end

  def mouse_pressed
    position = [mouse_x, mouse_y]
    controller.take_pit_if_available(position)
    controller.check_for_game_over
  end

end

Mancala.new