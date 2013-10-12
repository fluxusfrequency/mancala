class MancalaBoardView

  attr_reader :app

  def initialize(app)
    @app ||= app
  end

  def draw_board
    bg = app.load_image("../resources/images/mancala-board.jpg", "jpg")
    app.image(bg, 0, 0)
  end

  def draw_pits
    app.stroke 0
    app.fill 225
    app.model.all_pits.each do |pit|
      app.ellipse pit.x, pit.y, 150, 150
    end
  end

  def draw_stores
    app.stroke 0
    app.fill 225
    app.ellipse 115, 250, 150, 350
    app.ellipse 1305, 250, 150, 350
  end

  def draw_title
    app.text "MANCALA", 685, 25
  end

end
