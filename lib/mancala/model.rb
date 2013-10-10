class MancalaModel

  # If you run into your own store, deposit one piece in it.
  # If the last piece you drop is in an empty hole on your side, you capture that piece and any pieces in the hole directly opposite.
  # Always place all captured pieces in your store.
  # The player who still has pieces on his side of the board when the game ends captures all of those pieces.

  # What are all the pit and store objects in the game?
  # Find a pit or store by its id.
  # Find all the empty pits.
  # How many pieces are in each store and pit?

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
    pit_counts[count]
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





  # def available_pits
  #   all_pits - empty_pits
  # end

  # def empty_pits
  #   controller.empty_pits
  # end

  # def current_players_store_count
  #   store_count_of(app.ruler.current_player)
  # end

  # def opponents_store_count
  #   if app.ruler.current_player == app.ruler.player_1
  #     opponent = app.ruler.player_2
  #   else
  #     opponent = app.ruler.player_1
  #   end
  #     store_count_of(opponent)
  # end

  # def take_pit(pit)
  #   app.controller.recount_pits_starting_from(pit)
  #   controller.empty_pit(pit)
  # end

  # def store_count_of(player)
  #   store1 if player.id == 1
  #   player_2_store if player.id == 2
  # end

end