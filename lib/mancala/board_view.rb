class MancalaBoardView

  # What does the board look like?
  # What do the pits look like?
  # What do the stores look like?

  attr_reader :app

  def initialize(app)
    @app ||= app
  end

  def draw_board
    app.fill 106
    app.stroke 0
    app.rect 20, 55, 1385, 400
    app.stroke 206
    app.fill 256, 256, 256
    app.rect 20, 50, 1385, 400
    draw_title

    app.stroke 0
    app.fill 225
    draw_pits
    draw_stores
  end

  def draw_pits
    app.controller.all.each do |pit|
      app.ellipse pit.x, pit.y, 150, 150
    end
  end

  def draw_stores
    app.ellipse 115, 250, 150, 350
    app.ellipse 1305, 250, 150, 350
  end

  def draw_title
    app.text "MANCALA", 685, 25
  end

end