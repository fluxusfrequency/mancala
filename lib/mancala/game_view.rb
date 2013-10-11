class MancalaGameView

  attr_reader :app, :xfix, :yfix
  attr_accessor :random_colors

  def initialize(app)
    @app ||= app
    @random_colors ||= []
    build_random_colors
    @xfix = -13
    @yfix = -7
  end

  def build_random_colors
    48.times do
      random_colors << [rand(256), rand(256), rand(256)]
    end
  end

  def fill_a_random_color(num)
    colors = {
      1 => "blue",
      2 => "green",
      3 => "red",
      4 => "teal",
      5 => "yellow",
      6 => "blue",
      7 => "green",
      8 => "red",
      9 => "teal",
      10 => "yellow",
      11 => "teal",
      12 => "yellow",
    }
    bead = app.load_image("../resources/images/bead-#{colors[num]}.png", "png")
  end

  def draw_all_beads
    app.model.all_pits.each do |pit|
      draw_beads_in_pit(pit)
    end
    app.model.all_stores.each do |store|
      draw_beads_in_store(store)
    end
    print_winner if app.ruler.game_over?
  end

  def draw_beads_in_pit(pit)
    app.fill 225
    n = pit.count
    return if n == 0
    if n >= 1 && n <= 9
      draw_x_beads(pit, n)
    else
      draw_many_beads(pit)
    end
  end

  def draw_x_beads(pit, n)
    for i in 0..(n-1) do
      bead = fill_a_random_color(i+1)
      app.image(bead, pit.x+xfix+offsets[i][0], pit.y+yfix+i+offsets[i][1])
    end
  end

  def draw_many_beads(pit)

    for i in 0..8 do
      bead = fill_a_random_color(i+1)
      app.image(bead, pit.x+xfix+offsets[i][0], pit.y+yfix+offsets[i][1])
    end

    app.fill 0
    app.textSize(56)
    app.text "#{pit.count}", pit.x+xfix-10, pit.y+yfix-25
  end

  def offsets
    @offsets ||= [[25, 0], [-25, 0], [0, 25], [0, -25], [0,0], [-25, -25], [-25, 25], [25, -25], [25, 25]]
  end

  def draw_beads_in_store(store)
    fill_a_random_color(1)
    if store.id == 1
      draw_beads_in_player_one_store
    elsif store.id == 2
      draw_beads_in_player_two_store
    end
  end

  def draw_beads_in_player_one_store
    count = app.model.find_store_count_by_id(1)
    case count
    when 0
      return
    when 1
      bead = fill_a_random_color(12)
      app.image(bead, 1318, 238)
    else
      app.fill 0
      app.textSize(56)
      app.text "#{count}", 1290, 250
    end
  end

  def draw_beads_in_player_two_store
    count = app.model.find_store_count_by_id(2)
    case count
    when 0
      return
    when 1
      bead = fill_a_random_color(12)
      app.image(bead, 118, 238)
    else
      app.fill 0
      app.textSize(56)
      app.text "#{count}", 90, 250
    end
  end

  def invite_move
    message_1 = app.load_image("../resources/images/move-player1.png", "png")
    app.image(message_1, 530, 450) if app.ruler.current_player.id == 1
    message_2 = app.load_image("../resources/images/move-player2.png", "png")
    app.image(message_2, 530, 450) if app.ruler.current_player.id == 2
  end

  def print_winner
    app.textSize(56)
    fill_a_random_color(rand(12))
    app.text "Player one is the winner!", 640, 475 if app.ruler.winner == :player_1
    app.text "Player two is the winner!", 400, 250 if app.ruler.winner == :player_2
    app.text "Tie Game!", 640, 475 if app.ruler.winner == :id
  end

end
