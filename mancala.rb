require 'ruby-processing'

class MancalaPitController
  attr_reader :app
  attr_accessor :pit1,
                :pit2,
                :pit3,
                :pit4,
                :pit5,
                :pit6,
                :pit7,
                :pit8,
                :pit9,
                :pit10,
                :pit11,
                :pit12,
                :player_1_store
                :player_2_store

  def initialize(app)
    @app = app
    setup_pits
    setup_stores
  end

  def return_location_of_pit(pit)
    [pit.x, pit.y]
  end

  def return_count_of_pit(pit)
    pit.count
  end

  def empty_pit(pit)
    pit.count = 0
  end

  def take_if_available(pit)
    pit.empty?
    app.model.take_pit
  end

  def location_for_number_of_beads(n)
    case n
    when 1 then [[x, y]]
    when 2 then [[x-37, y] [x+37, y]]
    when 3 then [[x, y+37], [x-37, y-37], [x-37, y+37]]
    when 4 then [[x-37, y-37], [x+37, y-37], [x-37, y+37], [x+37, y+37]]
    else
      [[]]
    end
  end

  def all
    @all ||= [pit1,
              pit2,
              pit3,
              pit4,
              pit5,
              pit6,
              pit7,
              pit8,
              pit9,
              pit10,
              pit11,
              pit12]
  end

  def setup_pits
    @pit1 = MancalaPit.new([285, 350])
    @pit2 = MancalaPit.new([455, 350])
    @pit3 = MancalaPit.new([625, 350])
    @pit4 = MancalaPit.new([795, 350])
    @pit5 = MancalaPit.new([965, 350])
    @pit6 = MancalaPit.new([1135, 350])
    @pit7 = MancalaPit.new([1135, 150])
    @pit8 = MancalaPit.new([965, 150])
    @pit9 = MancalaPit.new([795, 150])
    @pit10 = MancalaPit.new([625, 150])
    @pit11 = MancalaPit.new([455, 150])
    @pit12 = MancalaPit.new([285, 150])
  end

  def setup_stores
    @player_1_store = MancalaStore.new(115)
    @player_2_store = MancalaStore.new(1305)
  end

end

class MancalaPit
  attr_reader :location, :x, :y, :count

  def initialize(location)
    @location = location
    @x = location[0]
    @y = location[1]
    @count ||= 4
  end

  def empty?
    count == 0
  end

end

class MancalaStore
  attr_reader :count

  def initialize(location)
    @count ||= 0
  end

end

class MancalaBoardView

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
    app.pit_controller.all.each do |pit|
      app.ellipse pit.x, pit.y, 150, 150
    end
  end

  def draw_stores
    app.ellipse 115, 250, 150, 350
    app.ellipse 1305, 250, 150, 350
  end

  def draw_title
    app.text "MANCALA", 628, 25
  end

end

class MancalaGameView
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
    puts "random_colors"
    app.fill(random_colors[num][0], random_colors[num][1], random_colors[num][2])
  end

  def draw_beads
    app.pit_controller.all.each_with_index do |pit, i|
      fill_a_random_color(i)
      app.ellipse pit.x-25, 125, 25, 25
      fill_a_random_color(i+1)
      app.ellipse pit.x+25, 125, 25, 25
      fill_a_random_color(i+2)
      app.ellipse pit.x-25, 175, 25, 25
      fill_a_random_color(i+3)
      app.ellipse pit.x+25, 175, 25, 25
      fill_a_random_color(i+4)
      app.ellipse pit.x-25, 325, 25, 25
      fill_a_random_color(i+5)
      app.ellipse pit.x+25, 325, 25, 25
      fill_a_random_color(i+6)
      app.ellipse pit.x-25, 375, 25, 25
      fill_a_random_color(i+7)
      app.ellipse pit.x+25, 375, 25, 25
    end
  end

  # def redraw_pit(pit)
  #   app.pit_controller.return_location_of_pit(pit)
  # end

end

class MancalaModel
  attr_reader :app
  attr_accessor :all_pits

  def initialize(app)
    @app ||= app
    @pit_controller ||= app.pit_controller
    @all_pits = pit_controller.all
  end

  def available_pits
    all_pits - taken_pits
  end

  def players_inventory(player)

  end

  def take_pit(pit)
    pit_controller.return_count_of_pit(pit)
    # do some stuff with the beads taken
    pit.controller.empty_pit(pit)
  end

end

class MancalaKalahRules
  attr_reader :app
  attr_accessor :current_player, :game_over

  def initialize(app)
    @app ||= app
    @game_over = false
  end

  def create_player(n)
    return unless n == 1 || 2
    MancalaPlayer.new(n)
  end

  def current_player
    @current_player ||= app.player_1
  end

  def change_player
    if @current_player == app.player_1
      @current_player = app.player_2
    else
      @current_player = app.player_1
    end
  end

  def has_turn?(player)
    player == current_player
  end

end

class MancalaPlayer
  attr_reader :id

  def initialize(id)
    @id = id
  end

end

class Mancala < Processing::App

  attr_reader :board, :view, :model, :pit_controller, :ruler
  attr_accessor :player_1, :player_2

  def setup
    size 1425, 500
    background 0
    @pit_controller = MancalaPitController.new(self)
    @board = MancalaBoardView.new(self)
    @view = MancalaGameView.new(self)
    @model = MancalaModel.new(self)
    @ruler = MancalaKalahRules.new(self)
    @player_1 ||= ruler.create_player(1)
    @player_2 ||= ruler.create_player(2)
  end

  def draw
    board.draw_board
    view.draw_beads
  end

  def mouse_pressed
    position = [mouse_x, mouse_y]
    pit_controller.take_if_available(pit)
    # check_for_win
    # change_player
  end

end

Mancala.new