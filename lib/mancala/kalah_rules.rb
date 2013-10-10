class MancalaKalahRules

  # The game begins with one player picking up all of the pieces in any one of the holes on his side.
  # Moving counter-clockwise, the player deposits one of the stones in each hole until the stones run out.
  # If you run into your own store, deposit one piece in it. If you run into your opponent's store, skip it.
  # If the last piece you drop is in your own store, you get a free turn.
  # If the last piece you drop is in an empty hole on your side, you capture that piece and any pieces in the hole directly opposite.
  # The game ends when all six spaces on one side of the Mancala board are empty.
  # The player who still has pieces on his side of the board when the game ends captures all of those pieces.
  # Count all the pieces in each store. The winner is the player with the most pieces.

  # Which direction do moves go?
  # Which pits are legal moves?
  # Where do the beads go when a player selects a pit?
  # What happens if I land on a given pit?
  # Is the game over?
  # Where do leftover beads go if the game is over?
  # Who won?

  attr_reader :app, :player_1, :player_2
  attr_accessor :current_player

  def initialize(app)
    @app ||= app
    setup_players
  end

  def setup_players
    @player_1 ||= MancalaPlayer.new(1)
    @player_2 ||= MancalaPlayer.new(2)
  end

  def current_player
    @current_player ||= player_1
  end

  def change_player
    if @current_player == player_1
      @current_player = player_2 # unless extra_turn
    elsif @current_player == player_2
      @current_player = player_1 # unless extra_turn
    end
    # extra_turn = false
  end

  def player_1_side_pit_ids
    [1, 2, 3, 4, 5, 6]
  end

  def player_2_side_pit_ids
    [7, 8, 9, 10, 11, 12]
  end

  def legal_pit?(pit_id, player)
    if app.model.find_pit_by_id(pit_id).empty?
      return false
    end

    if player.id == 1
      player_1_side_pit_ids.include?(pit_id)
    elsif player.id == 2
      player_2_side_pit_ids.include?(pit_id)
    end
  end

  def distribute_beads_from(pit_id, player)
    count = app.model.find_pit_by_id(pit_id).count
    distribute_beads_for_player(player, pit_id, count)
  end

  def distribute_beads_for_player(player, first_pit_id, count)
    next_pit_id = app.model.find_next_pit_by_id(first_pit_id)

    i = 0
    while i < count do
      if next_pit_id == 7 && player.id == 1
        distribute_into_store(1)
        i += 1
        return if i == count
      elsif next_pit_id == 1 && player.id == 2
        distribute_into_store(2)
        i += 1
        return if i == count
      end
      app.model.add_bead_to_pit(next_pit_id)
      next_pit_id = app.model.find_next_pit_by_id(next_pit_id)
      i += 1
    end

  end

  def distribute_into_store(store_id)
    app.model.add_bead_to_store(store_id)
  end

  # def recount_pits_starting_from(first_pit)
  #   app.view.draw_no_beads(first_pit)
  #   next_pit = find_next_pit(first_pit)
  #   pits_to_fill = first_pit.count
  #   @hit_a_store = false
  #   for i in 1..pits_to_fill do
  #     store_logic(i, pits_to_fill, next_pit)
  #     add_bead_to_pit(next_pit)
  #     puts "player: #{app.ruler.current_player.id}, iter:#{i}, next_pit: #{next_pit.id}, pits_to_fill: #{pits_to_fill}, pit count: #{next_pit.count} \n*******"
  #     if i == pits_to_fill && app.ruler.current_player.my_pit_ids.include?(next_pit.id) && next_pit.count == 1
  #       puts "landed on an empty pit"
  #       capture_from_empty(next_pit)
  #     end
  #     next_pit = find_next_pit(next_pit)
  #   end
  #   fix_beads_after_store_hit(next_pit) if @hit_a_store
  # end

  def player_1_distribution_targets
    @player_1_distribution_targets ||= [
    app.model.pit1, app.model.pit2,
    app.model.pit3, app.model.pit4,
    app.model.pit5, app.model.pit6,
    app.model.store1, app.model.pit7,
    app.model.pit8, app.model.pit9,
    app.model.pit10, app.model.pit11,
    app.model.pit12 ]
  end

  def player_2_distribution_targets
    @player_2_distribution_targets ||= [
    app.model.pit1, app.model.pit2,
    app.model.pit3, app.model.pit4,
    app.model.pit5, app.model.pit6,
    app.model.pit7, app.model.pit8,
    app.model.pit9, app.model.pit10,
    app.model.pit11, app.model.pit12,
    app.model.store2 ]
  end



  # def all_empty_on_one_side?
  #   app.controller.all_empty_pits.all? do |pit|
  #     player_1_side_pits.include?(pit.id)
  #   end
  #   app.controller.all_empty_pits.all? do |pit|
  #     player_2_side_pits.include?(pit.id)
  #   end
  # end

  # def compare_scores
  #   if app.controller.player_1_store.count > app.controller.player_1_store.count
  #     return :player_1_win
  #   elsif app.controller.player_1_store.count < app.controller.player_1_store.count
  #     return :player_2_win
  #   elsif app.controller.player_1_store.count = app.controller.player_1_store.count
  #     return :tie
  #   else
  #     return
  #   end
  # end

  # def declare_winner
  #   if compare_scores == :player_1_win
  #     @winner = app.ruler.player_1
  #   elsif compare_scores == :player_2_win
  #     @winner = app.ruler.player_1
  #   elsif compare_scores == :tie
  #     # app.view.print_tie
  #     return
  #   else
  #     return
  #   end
  #   app.view.print_winner(@winner)
  # end

  # def check_and_execute_game_over
  #   if !all_empty_on_one_side?
  #     return
  #   end
  #   game_over = true
  #   app.controller.clear_remaining_beads
  # end

end
