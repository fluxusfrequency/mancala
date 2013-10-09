require 'ruby-processing'

class MancalaPitController

  # Maybe this is a model?
  # Which pits are in this game?
  # Which stores are in this game?

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
                :player_1_store,
                :player_2_store

  def initialize(app)
    @app = app
    setup_pits
    setup_stores
  end

  def location_of_pit(pit)
    [pit.x, pit.y]
  end

  def return_count_of_pit(pit)
    pit.count
  end

  def empty_pit(pit)
    pit.count = 0
  end

  def take_pit_if_available(coordinates)
    return if coordinates[0] == 0 || coordinates[1] == 0
    found_pit = find_pit_by_coordinates(coordinates)
    if valid_move?(found_pit)
      execute_take
    end
  end

  def execute_take
    app.model.take_pit(found_pit)
    app.ruler.change_player
    app.view.redraw_pit(pit)
  end

  def valid_move?(pit)
    !pit.empty? && app.ruler.valid_pits_for_player(app.ruler.current_player).include?(pit.id)
  end

  def find_pit_by_coordinates(coordinates)
    all.each do |pit|
      # puts "Pit #{pit.id} range: x #{pit.x-75}, #{pit.x+75} | #{pit.y-75}, #{pit.y+75}"
    end
    all.each do |pit|
      x_range, y_range = (pit.x-75..pit.x+75), (pit.y-75..pit.y+75)
      in_x = x_range.include? coordinates[0]
      in_y = y_range.include? coordinates[1]
      @found = pit if in_x && in_y
    end
    @found
  end

  def move_beads
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
    @pit1 = MancalaPit.new(1, [285, 350])
    @pit2 = MancalaPit.new(2, [455, 350])
    @pit3 = MancalaPit.new(3, [625, 350])
    @pit4 = MancalaPit.new(4, [795, 350])
    @pit5 = MancalaPit.new(5, [965, 350])
    @pit6 = MancalaPit.new(6, [1135, 350])
    @pit7 = MancalaPit.new(7, [1135, 150])
    @pit8 = MancalaPit.new(8, [965, 150])
    @pit9 = MancalaPit.new(9, [795, 150])
    @pit10 = MancalaPit.new(10, [625, 150])
    @pit11 = MancalaPit.new(11, [455, 150])
    @pit12 = MancalaPit.new(12, [285, 150])
  end

  def setup_stores
    @player_1_store = MancalaStore.new(1)
    @player_2_store = MancalaStore.new(2)
  end

end

class MancalaPit

  # What is my id?
  # What are my coordinates?
  # How many pieces do I currently contain?
  # Am I empty?

  attr_reader :id, :location, :x, :y
  attr_accessor :count

  def initialize(id, location)
    @id = id
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

  # How many pieces do I currently contain?
  # Am I empty?
  # Which player do I belong to?

  attr_reader :id, :count

  def initialize(id)
    @count ||= 0
    @id = id
  end

  def empty?
    count == 0
  end

  def player
    app.players.select{|player| player.id == player_id}
  end

end

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

  def location_for_number_of_beads(n)
    case n
    when 1 then [[x, y]]
    when 2 then [[x-37, y], [x+37, y]]
    when 3 then [[x, y+37], [x-37, y-37], [x-37, y+37]]
    when 4 then [[x-37, y-37], [x+37, y-37], [x-37, y+37], [x+37, y+37]]
    else
      [[]]
    end
  end

  def invite_move
    app.background 0,0,0
    app.fill 256, 256, 256
    app.text "  -     Player one, your move!", 700, 25 if app.ruler.current_player.id == 1
    app.text "  -     Player two, your move!", 700, 25 if app.ruler.current_player.id == 2
  end

  def redraw_pit(pit)
    app.ellipse pit.x, pit.y, 150, 150
  end

  # def draw_pits
  #   app.pit_controller.all.each do |pit|
  #     app.ellipse pit.x, pit.y, 150, 150
  #   end
  # end

end

class MancalaModel

  # How many pieces are in the current player's store?
  # How many pieces are in the opponent's store?
  # How many pieces are in each pit? (hash)

  attr_reader :app, :pit_controller
  attr_accessor :all_pits, :player_1_store, :player_2_store, :current_count

  def initialize(app)
    @app ||= app
    @pit_controller ||= app.pit_controller
    @all_pits = @pit_controller.all
    @player_1_store = 0
    @player_2_store = 0
  end

  def available_pits
    all_pits - empty_pits
  end

  def store_count_of(player)
    player_1_store if player.id == 1
    player_2_store if player.id == 2
  end

  def empty_pits
    pit_controller.empty_pits
  end

  def current_players_store_count
    store_count_of(app.ruler.current_player)
  end

  def opponents_store_count
    if app.ruler.current_player == app.player_1
      opponent = app.player_2
    else
      opponent = app.player_1
    end
      store_count_of(opponent)
  end

  def take_pit(pit)
    @current_count = pit_controller.return_count_of_pit(pit)
    pit_controller.empty_pit(pit)
  end

end

class MancalaKalahRules

  # Which direction do moves go?
  # Which pits are legal moves?
  # Where do the beads go when a player selects a pit?
  # What happens if I land on a given pit?
  # Is the game over?
  # Where do leftover beads go if the game is over?
  # Who won?

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

  def valid_pits_for_player(player)
    if player.id == 1
      [1, 2, 3, 4, 5, 6]
    else
      [7, 8, 9, 10, 11, 12]
    end
  end

  def has_turn?(player)
    player == current_player
  end


end

class MancalaPlayer

  # Which pits can I move from?
  # Which store is mine?
  # How many beads are in my store?

  attr_reader :id

  def initialize(id)
    @id = id
  end

  def my_pit_ids
    if id == 1
      [1, 2, 3, 4]
    else
      [5, 6, 7, 8]
    end
  end

  def my_store_id
    id
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
    view.invite_move
    board.draw_board
    view.draw_beads
  end

  def mouse_pressed
    position = [mouse_x, mouse_y]
    pit_controller.take_pit_if_available(position)
    # check_for_win
  end

  # def players
  #   [player_1, player_2]
  # end

end

Mancala.new