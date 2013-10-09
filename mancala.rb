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

  def add_bead_to_pit(pit)
    pit.count += 1
  end

  def remove_bead_from_pit(pit)
    pit.count -= 1
  end

  def add_bead_to_store(store)
    store.count += 1
  end

  def empty_pit(pit)
    pit.count = 0
  end

  def take_pit_if_available(coordinates)
    return if coordinates[0] == 0 || coordinates[1] == 0
    found_pit = find_pit_by_coordinates(coordinates)
    if valid_move?(found_pit)
      execute_take(found_pit)
    end
  end

  def execute_take(pit)
    app.model.take_pit(pit)
    app.ruler.change_player
    app.ruler.extra_turn = false
  end

  def recount_pits_starting_from(first_pit)
    app.view.draw_no_beads(first_pit)
    next_pit = find_next_pit(first_pit)
    pits_to_fill = first_pit.count
    @hit_a_store = false
    for i in 1..pits_to_fill do
      store_logic(i, pits_to_fill, next_pit)
      add_bead_to_pit(next_pit)
      app.view.draw_beads_in_pit(next_pit)
      # FIX HERE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      # capture_from_empty(next_pit) if landed_on_empty_pit?(next_pit, i, pits_to_fill)
      next_pit = find_next_pit(next_pit)
    end
    fix_beads_after_store_hit(next_pit) if @hit_a_store
  end

  def fix_beads_after_store_hit(next_pit)
    last_pit = find_last_pit(next_pit)
    remove_bead_from_pit(last_pit)
    app.view.draw_beads_in_pit(next_pit)
  end

  def store_logic(i, pits_to_fill, next_pit)
    if app.ruler.current_player.id == 1 && next_pit.id == 7
      app.ruler.extra_turn = true if last_move?(i, pits_to_fill)
      add_bead_to_store(player_1_store)
      app.view.draw_beads_in_store(player_1_store)
      @hit_a_store = true
    elsif app.ruler.current_player.id == 2 && next_pit.id == 1
      app.ruler.extra_turn = true if last_move?(i, pits_to_fill)
      # puts "player: #{app.ruler.current_player.id}, iter:#{i}, next_pit: #{next_pit.id}, pits_to_fill: #{pits_to_fill}, extra_turn: #{app.ruler.extra_turn} \n*******"
      add_bead_to_store(player_2_store)
      app.view.draw_beads_in_store(player_2_store)
      @hit_a_store = true
    end
  end

  def landed_on_empty_pit?(pit, i, pits_to_fill)
    last_move?(i, pits_to_fill) && pit.count = 0
  end

  def last_move?(i, pits_to_fill)
    i == pits_to_fill
  end

  def capture_from_empty(pit)
    opposite_pit_id = opposite_pit_id(pit)
    opposite_pit = find_pit_by_id(opposite_pit_id)
    beads_to_take = opposite_pit.count + 1
    beads_to_take.times do
      add_bead_to_store(current_players_store)
    end
    empty_pit(pit)
    empty_pit(opposite_pit)
  end

  def opposite_pit_id(pit)
    opposites = { 1 => 12,
                  2 => 11,
                  3 => 10,
                  4 => 9,
                  5 => 8,
                  6 => 7,
                  7 => 6,
                  8 => 5,
                  9 => 4,
                  10 => 3,
                  11 => 2,
                  12 => 1 }
    opposites[pit.id]
  end

  def current_players_store
    return player_1_store if app.ruler.current_player.id == 1
    return aplayer_2_store if app.ruler.current_player.id == 2
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

  def find_next_pit(first_pit)
    if first_pit.id == 12
      all.find {|pit| pit.id == 1}
    else
      all.find {|pit| pit.id == first_pit.id + 1}
    end
  end

  def find_last_pit(first_pit)
    if first_pit.id == 1
      all.find {|pit| pit.id == 12}
    else
      all.find {|pit| pit.id == first_pit.id - 1}
    end
  end

  def find_pit_by_id(id)
    all.find {|pit| pit.id == id}
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

  def all_stores
    @all_stores ||= [player_1_store, player_2_store]
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

  attr_reader :id
  attr_accessor :count

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
    app.text "MANCALA", 685, 25
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

  def draw_all_beads
    app.pit_controller.all.each do |pit|
      draw_beads_in_pit(pit)
    end
    app.pit_controller.all_stores.each do |store|
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
    count =  app.pit_controller.player_1_store.count
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
    count = app.pit_controller.player_2_store.count
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
    app.pit_controller.recount_pits_starting_from(pit)
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
  attr_accessor :current_player, :game_over, :extra_turn

  def initialize(app)
    @app ||= app
    @game_over = false
    @extra_turn = false
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
      @current_player = app.player_2 unless extra_turn
    elsif @current_player == app.player_2
      @current_player = app.player_1 unless extra_turn
    end
    extra_turn = false
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

  attr_reader :board, :view, :model, :pit_controller
  attr_accessor :player_1, :player_2, :ruler

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
    view.draw_all_beads
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