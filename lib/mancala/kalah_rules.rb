class MancalaKalahRules

  attr_reader :app, :player_1, :player_2
  attr_accessor :current_player, :extra_turn, :winner

  def initialize(app)
    @app ||= app
    @extra_turn = false
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
      @current_player = player_2 unless @extra_turn
    elsif @current_player == player_2
      @current_player = player_1 unless @extra_turn
    end
    @extra_turn = false
  end

  def legal_pit?(pit_id, player)
    if app.model.find_pit_by_id(pit_id).empty?
      return false
    end

    if player.id == 1
      app.model.player_1_side_pit_ids.include?(pit_id)
    elsif player.id == 2
      app.model.player_2_side_pit_ids.include?(pit_id)
    end
  end

  def distribute_beads_from(pit_id, player)
    count = app.model.find_pit_by_id(pit_id).count
    distribute_beads_for_player(pit_id, player, count)
    app.model.empty_pit(pit_id)
  end

  def distribute_beads_for_player(first_pit_id, player, count)
    next_pit_id = app.model.find_next_pit_by_id(first_pit_id)

    @i = 0
    while @i <= count do
      execute_store_logic(next_pit_id, player, count)
      break if @i == count
      app.model.add_bead_to_pit(next_pit_id)
      next_pit_id = app.model.find_next_pit_by_id(next_pit_id)
      if @i == count - 1
        landing_spot = next_pit_id - 1
        landing_spot = 12 if landing_spot == 0
        if landed_on_empty?(landing_spot) && app.model.find_all_pit_ids_on_players_side(player).include?(landing_spot)
          take_both_sides(landing_spot)
        end
      end
      @i += 1
    end
  end

  def execute_store_logic(next_pit_id, player, count)
    if going_into_players_store?(next_pit_id, player)
      distribute_into_store(player.id)
      @i += 1
      extra_turn_if_landed_on_store(count)
    end
  end

  def going_into_players_store?(next_pit_id, player)
    next_pit_id == 7 && player.id == 1 || next_pit_id == 1 && player.id == 2
  end

  def extra_turn_if_landed_on_store(count)
    if @i == count
      @extra_turn = true
    end
  end

  def distribute_into_store(store_id)
    app.model.add_bead_to_store(store_id)
  end

  def take_both_sides(pit_id)
    take_this_side(pit_id)
    take_that_side(pit_id)
  end

  def take_this_side(pit_id)
    current_players_store.count += 1
    app.model.empty_pit(pit_id)
  end

  def take_that_side(pit_id)
    current_players_store.count += opposing_pit(pit_id).count
    app.model.empty_pit(opposing_pit(pit_id).id)
  end

  def opposing_pit(pit_id)
    app.model.find_opposite_pit_by_id(pit_id)
  end

  def current_players_store
    app.model.find_store_by_id(current_player.id)
  end

  def landed_on_empty?(pit_id)
    app.model.find_pit_by_id(pit_id).count == 1
  end

  def game_over?
    app.model.all_empty_on_one_side?
  end

  def execute_end_game
    take_remaining_beads_on_game_over
    declare_winner
  end

  def take_remaining_beads_on_game_over
    if app.model.empty_on_player_1_side?
      take_remaining_beads_from_players_side(player_2)
    elsif app.model.empty_on_player_2_side?
      take_remaining_beads_from_players_side(player_1)
    end
  end

  def take_remaining_beads_from_players_side(player)
    app.model.find_all_pits_on_players_side(player).each do |pit|
      players_store(player).count += pit.count
      pit.count = 0
    end
  end

  def players_store(player)
    app.model.find_store_by_id(player.id)
  end

  def player_1_won?
    score_for_player(player_1) > score_for_player(player_2)
  end

  def player_2_won?
    score_for_player(player_1) < score_for_player(player_2)
  end

  def tie?
    score_for_player(player_1) == score_for_player(player_2)
  end

  def declare_winner
    @winner = :player_1 if player_1_won?
    @winner = :player_2 if player_2_won?
    @winner = :tie if tie?
    return
  end

  def score_for_player(player)
    app.model.find_store_count_by_id(player.id)
  end

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
