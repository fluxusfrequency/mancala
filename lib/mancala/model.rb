class MancalaModel

  attr_reader :app, :controller, :all_stores
  attr_accessor :all_pits, :store1, :store2, :current_count,
                :pit1, :pit2, :pit3, :pit4, :pit5, :pit6,
                :pit7, :pit8, :pit9, :pit10, :pit11, :pit12

  def initialize(app)
    @app ||= app
    @controller ||= app.controller
    setup_pits
    setup_stores
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
    @store1 = MancalaStore.new(1)
    @store2 = MancalaStore.new(2)
  end

  def all_pits
    @all_pits ||= [ pit1, pit2, pit3, pit4,
                    pit5, pit6, pit7, pit8,
                    pit9, pit10, pit11, pit12 ]
  end

  def opposites
    { 1 => 12, 2 => 11, 3 => 10, 4 => 9, 5 => 8,
      6 => 7, 7 => 6, 8 => 5, 9 => 4, 10 => 3,
      11 => 2, 12 => 1 }
  end

  def all_stores
    @all_stores ||= [store1, store2]
  end

  def find_pit_by_id(id)
    all_pits.find {|pit| pit.id == id}
  end

  def find_next_pit_by_id(first_pit_id)
    if first_pit_id < 12
      next_pit_id = first_pit_id + 1
    elsif first_pit_id == 12
      next_pit_id = 1
    end
  end

  def find_store_by_id(id)
    all_stores.find {|store| store.id == id}
  end

  def find_all_pits_by_count(count)
    pit_counts[count] || []
  end

  def find_pit_count_by_id(id)
    find_pit_by_id(id).count
  end

  def find_store_count_by_id(id)
    find_store_by_id(id).count
  end

  def pit_counts
    all_pits.group_by(&:count)
  end

  def store_counts
    all_stores.group_by(&:count)
  end

  def add_bead_to_pit(id)
    find_pit_by_id(id).count += 1
  end

  def remove_bead_from_pit(id)
    find_pit_by_id(id).count -= 1
  end

  def add_bead_to_store(id)
    find_store_by_id(id).count += 1
  end

  def empty_pit(id)
    find_pit_by_id(id).count = 0
  end

  def find_opposite_pit_by_id(id)
    find_pit_by_id(opposites[id])
  end

  def all_empty_on_one_side?
    empty_on_player_1_side? || empty_on_player_2_side?
  end

  def empty_pit_ids
    empty_pit_ids = find_all_pits_by_count(0).collect(&:id) || []
  end

  def empty_on_player_1_side?
    player_1_side_pit_ids.all?{|pit| empty_pit_ids.include?(pit)}
  end

  def empty_on_player_2_side?
    player_2_side_pit_ids.all?{|pit| empty_pit_ids.include?(pit)}
  end

  def player_1_side_pit_ids
    [1, 2, 3, 4, 5, 6]
  end

  def player_2_side_pit_ids
    [7, 8, 9, 10, 11, 12]
  end

  def player_1_side_pits
    player_1_side_pit_ids.collect do |id|
      find_pit_by_id(id)
    end
  end

  def player_2_side_pits
    player_2_side_pit_ids.collect do |id|
      find_pit_by_id(id)
    end
  end

  def find_all_pits_on_players_side(player)
    if player.id == 1
      player_1_side_pits
    elsif player.id == 2
      player_2_side_pits
    end
  end

  def find_all_pit_ids_on_players_side(player)
    if player.id == 1
      player_1_side_pit_ids
    elsif player.id == 2
      player_2_side_pit_ids
    end
  end


end