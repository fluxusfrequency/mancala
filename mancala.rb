require 'ruby-processing'

class MancalaBoardView

  attr_reader :app

  def initialize(app)
    @app ||= app
  end

  def draw_board
    app.stroke 256
    app.rect 50, 50, 800, 400
    draw_title
    draw_circles
  end

  def draw_circles
    app.stroke 0
    app.ellipse 125, 150, 100, 125
    app.ellipse 125, 350, 100, 125
    app.ellipse 250, 150, 100, 125
    app.ellipse 250, 350, 100, 125
    app.ellipse 375, 150, 100, 125
    app.ellipse 375, 350, 100, 125
    app.ellipse 525, 150, 100, 125
    app.ellipse 525, 350, 100, 125
    app.ellipse 650, 150, 100, 125
    app.ellipse 650, 350, 100, 125
    app.ellipse 775, 150, 100, 125
    app.ellipse 775, 350, 100, 125
  end

  def draw_title
    app.text "MANCALA", 415, 25
  end

end

class MancalaGameView
  attr_reader :app

  def initialize(app)
    @app ||= app
  end

  def draw_game
    app.ellipse 100, 125, 25, 25
    app.ellipse 150, 125, 25, 25
    app.ellipse 100, 175, 25, 25
    app.ellipse 150, 175, 25, 25

    app.ellipse 225, 125, 25, 25
    app.ellipse 275, 125, 25, 25
    app.ellipse 225, 175, 25, 25
    app.ellipse 275, 175, 25, 25

    app.ellipse 350, 125, 25, 25
    app.ellipse 400, 125, 25, 25
    app.ellipse 350, 175, 25, 25
    app.ellipse 400, 175, 25, 25

    app.ellipse 500, 125, 25, 25
    app.ellipse 550, 125, 25, 25
    app.ellipse 500, 175, 25, 25
    app.ellipse 550, 175, 25, 25

    app.ellipse 625, 125, 25, 25
    app.ellipse 675, 125, 25, 25
    app.ellipse 625, 175, 25, 25
    app.ellipse 675, 175, 25, 25

    app.ellipse 750, 125, 25, 25
    app.ellipse 800, 125, 25, 25
    app.ellipse 750, 175, 25, 25
    app.ellipse 800, 175, 25, 25

    app.ellipse 100, 325, 25, 25
    app.ellipse 150, 325, 25, 25
    app.ellipse 100, 375, 25, 25
    app.ellipse 150, 375, 25, 25

    app.ellipse 225, 325, 25, 25
    app.ellipse 275, 325, 25, 25
    app.ellipse 225, 375, 25, 25
    app.ellipse 275, 375, 25, 25

    app.ellipse 350, 325, 25, 25
    app.ellipse 400, 325, 25, 25
    app.ellipse 350, 375, 25, 25
    app.ellipse 400, 375, 25, 25

    app.ellipse 500, 325, 25, 25
    app.ellipse 550, 325, 25, 25
    app.ellipse 500, 375, 25, 25
    app.ellipse 550, 375, 25, 25

    app.ellipse 625, 325, 25, 25
    app.ellipse 675, 325, 25, 25
    app.ellipse 625, 375, 25, 25
    app.ellipse 675, 375, 25, 25

    app.ellipse 750, 325, 25, 25
    app.ellipse 800, 325, 25, 25
    app.ellipse 750, 375, 25, 25
    app.ellipse 800, 375, 25, 25

  end

end

class MancalaModel
  attr_reader :app

  def initialize(app)
    @app ||= app
    @current_player = 'x'
    @game_over = false
  end

end

class MancalaRuler
  attr_reader :app

  def initialize(app)
    @app ||= app
    # @current_player = :player_1
    # @game_over = false
  end

  # def change_player
  #   if @current_player == :player_1
  #     @current_player = :player_2
  #   else
  #     @current_player = :player_1
  #   end
  # end

end

class Mancala < Processing::App

  attr_reader :board, :view, :model, :ruler

  def setup
    size 900, 500
    @board = MancalaBoardView.new(self)
    @view = MancalaGameView.new(self)
    @model = MancalaModel.new(self)
    @ruler = MancalaRuler.new(self)
  end

  def draw
    board.draw_board
    view.draw_game
  end

end

Mancala.new