class MancalaModel

  # How many pieces are in the current player's store?
  # How many pieces are in the opponent's store?
  # How many pieces are in each pit? (hash)

  attr_reader :app, :controller
  attr_accessor :all_pits, :player_1_store, :player_2_store, :current_count

  def initialize(app)
    @app ||= app
    @controller ||= app.controller
    @all_pits = @controller.all
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
    controller.empty_pits
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
    app.controller.recount_pits_starting_from(pit)
    controller.empty_pit(pit)
  end

end