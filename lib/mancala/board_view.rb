class MancalaBoardView

  attr_reader :app

  def initialize(app)
    @app ||= app
  end

  def draw_board

    #box shadow
    app.stroke 0
    app.fill 106
    app.rect 25, 55, 1385, 400

    #main board
    app.stroke 206
    app.fill 256, 256, 256
    app.rect 20, 50, 1385, 400
    draw_title

    draw_pits
    draw_stores
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