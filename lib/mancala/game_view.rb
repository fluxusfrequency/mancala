class MancalaGameView

  # What do the beads look like?
  # How do I render a pit with
  # 0,1,2,3,4,5,6,7,8 or more beads?

  attr_reader :app
  attr_accessor :random_colors

  def initialize(app)
    @app ||= app
    @random_colors ||= []
    build_random_colors
  end

  def build_random_colors
    48.times do
      random_colors << [rand(256), rand(256), rand(256)]
    end
  end

  def fill_a_random_color(num)
    app.fill(random_colors[num][0], random_colors[num][1], random_colors[num][2])
  end

  def draw_all_beads
    app.controller.all.each do |pit|
      draw_beads_in_pit(pit)
    end
    app.controller.all_stores.each do |store|
      draw_beads_in_store(store)
    end
  end

  def draw_beads_in_pit(pit)
    app.fill 225
    case pit.count
    when 0 then draw_no_beads(pit)
    when 1 then draw_one_bead(pit)
    when 2 then draw_two_beads(pit)
    when 3 then draw_three_beads(pit)
    when 4 then draw_four_beads(pit)
    when 5 then draw_five_beads(pit)
    when 6 then draw_six_beads(pit)
    else
      draw_many_beads(pit)
    end
  end

  def draw_no_beads(pit)
    app.ellipse pit.x, pit.y, 150, 150
  end

  def draw_one_bead(pit)
    fill_a_random_color(1)
    app.ellipse pit.x, pit.y, 25, 25
  end

  def draw_two_beads(pit)
    fill_a_random_color(2)
    app.ellipse pit.x-25, pit.y, 25, 25
    fill_a_random_color(3)
    app.ellipse pit.x+25, pit.y, 25, 25
  end

  def draw_three_beads(pit)
    # [x, y+37], [x-37, y-37], [x-37, y+37]
    fill_a_random_color(4)
    app.ellipse pit.x, pit.y, 25, 25
    fill_a_random_color(5)
    app.ellipse pit.x+37, pit.y-37, 25, 25
    fill_a_random_color(6)
    app.ellipse pit.x-37, pit.y+37, 25, 25
  end

  def draw_four_beads(pit)
    fill_a_random_color(7)
    app.ellipse pit.x-25, pit.y-25, 25, 25
    fill_a_random_color(8)
    app.ellipse pit.x+25, pit.y-25, 25, 25
    fill_a_random_color(9)
    app.ellipse pit.x-25, pit.y+25, 25, 25
    fill_a_random_color(10)
    app.ellipse pit.x+25, pit.y+25, 25, 25
  end

  def draw_five_beads(pit)
    fill_a_random_color(11)
    app.ellipse pit.x-37, pit.y-37, 25, 25
    fill_a_random_color(12)
    app.ellipse pit.x+37, pit.y-37, 25, 25
    fill_a_random_color(1)
    app.ellipse pit.x-37, pit.y+37, 25, 25
    fill_a_random_color(2)
    app.ellipse pit.x+37, pit.y+37, 25, 25
    fill_a_random_color(3)
    app.ellipse pit.x, pit.y, 25, 25
  end

  def draw_six_beads(pit)
    fill_a_random_color(4)
    app.ellipse pit.x-37, pit.y-37, 25, 25
    fill_a_random_color(5)
    app.ellipse pit.x, pit.y-37, 25, 25
    fill_a_random_color(6)
    app.ellipse pit.x+37, pit.y-37, 25, 25
    fill_a_random_color(7)
    app.ellipse pit.x-37, pit.y+37, 25, 25
    fill_a_random_color(8)
    app.ellipse pit.x, pit.y+37, 25, 25
    fill_a_random_color(9)
    app.ellipse pit.x+37, pit.y+37, 25, 25
  end

  def draw_many_beads(pit)
    fill_a_random_color(10)
    app.ellipse pit.x-37, pit.y-37, 25, 25
    fill_a_random_color(11)
    app.ellipse pit.x-25, pit.y-25, 25, 25
    fill_a_random_color(12)
    app.ellipse pit.x-12, pit.y-12, 25, 25
    fill_a_random_color(1)
    app.ellipse pit.x, pit.y, 25, 25
    fill_a_random_color(2)
    app.ellipse pit.x+12, pit.y+12, 25, 25
    fill_a_random_color(3)
    app.ellipse pit.x+25, pit.y+25, 25, 25
    fill_a_random_color(4)
    app.ellipse pit.x+37, pit.y+37, 25, 25
    fill_a_random_color(5)
    app.ellipse pit.x-37, pit.y+37, 25, 25
    fill_a_random_color(6)
    app.ellipse pit.x-25, pit.y+25, 25, 25
    fill_a_random_color(7)
    app.ellipse pit.x-12, pit.y+12, 25, 25
    fill_a_random_color(8)
    app.ellipse pit.x, pit.y, 25, 25
    fill_a_random_color(9)
    app.ellipse pit.x-12, pit.y+12, 25, 25
    fill_a_random_color(10)
    app.ellipse pit.x-25, pit.y+25, 25, 25
    fill_a_random_color(11)
    app.ellipse pit.x-37, pit.y+37, 25, 25
    fill_a_random_color(12)
    app.ellipse pit.x+37, pit.y-37, 25, 25
    fill_a_random_color(1)
    app.ellipse pit.x+25, pit.y-25, 25, 25
    fill_a_random_color(2)
    app.ellipse pit.x+12, pit.y-12, 25, 25
    fill_a_random_color(3)
    app.ellipse pit.x, pit.y, 25, 25
    fill_a_random_color(4)
    app.ellipse pit.x+12, pit.y-12, 25, 25
    fill_a_random_color(5)
    app.ellipse pit.x+25, pit.y-25, 25, 25
    fill_a_random_color(6)
    app.ellipse pit.x+37, pit.y-37, 25, 25

    app.fill 0
    app.textSize(56)
    app.text "#{pit.count}", pit.x-10, pit.y-25
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
    count =  app.controller.player_1_store.count
    case count
    when 0
      return
    when 1
      app.ellipse 1330, 250, 25, 25
    else
      app.fill 0
      app.textSize(56)
      app.text "#{count}", 1290, 250
    end
  end

  def draw_beads_in_player_two_store
    count = app.controller.player_2_store.count
    case count
    when 0
      return
    when 1
      app.ellipse 130, 250, 25, 25
    else
      app.fill 0
      app.textSize(56)
      app.text "#{count}", 90, 250
    end
  end

  def invite_move
    app.background 0,0,0
    app.textSize(20)
    app.fill 256, 256, 256
    app.text "Player one, your move!", 640, 475 if app.ruler.current_player.id == 1
    app.text "Player two, your move!", 640, 475 if app.ruler.current_player.id == 2
  end

  def print_winner(winner)
    app.background 0,0,0
    app.textSize(56)
    app.text "Player one is the winner!", 640, 475 if winner.id == 1
    app.text "Player two is the winner!", 640, 475 if winner.id == 2
  end

  def print_tie
    app.background 0,0,0
    app.textSize(56)
    app.text "Tie Game!", 640, 475 if app.ruler.current_player.id == 1
  end

end