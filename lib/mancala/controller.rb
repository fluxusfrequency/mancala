class MancalaController

  def initialize(app)
    @app = app
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
      puts "player: #{app.ruler.current_player.id}, iter:#{i}, next_pit: #{next_pit.id}, pits_to_fill: #{pits_to_fill}, pit count: #{next_pit.count} \n*******"
      if i == pits_to_fill && app.ruler.current_player.my_pit_ids.include?(next_pit.id) && next_pit.count == 1
        puts "landed on an empty pit"
        capture_from_empty(next_pit)
      end
      next_pit = find_next_pit(next_pit)
    end
    fix_beads_after_store_hit(next_pit) if @hit_a_store
  end

  def fix_beads_after_store_hit(next_pit)
    last_pit = find_last_pit(next_pit)
    remove_bead_from_pit(last_pit)
  end

  def store_logic(i, pits_to_fill, next_pit)
    if app.ruler.current_player.id == 1 && next_pit.id == 7
      app.ruler.extra_turn = true if i == pits_to_fill
      add_bead_to_store(player_1_store)
      app.view.draw_beads_in_store(player_1_store)
      @hit_a_store = true
    elsif app.ruler.current_player.id == 2 && next_pit.id == 1
      app.ruler.extra_turn = true if i == pits_to_fill
      # puts "player: #{app.ruler.current_player.id}, iter:#{i}, next_pit: #{next_pit.id}, pits_to_fill: #{pits_to_fill}, extra_turn: #{app.ruler.extra_turn} \n*******"
      add_bead_to_store(player_2_store)
      app.view.draw_beads_in_store(player_2_store)
      @hit_a_store = true
    end
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

  def current_players_store
    return player_1_store if app.ruler.current_player.id == 1
    return player_2_store if app.ruler.current_player.id == 2
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

  def clear_remaining_beads
    pits_with_beads_left.each do |pit|
      beads_to_take = pit.count
      current_players_store.count += beads_to_take
      empty_pit(pit)
    end
  end

  def pits_with_beads_left
    all.collect {|pit| pit.count > 0}
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


