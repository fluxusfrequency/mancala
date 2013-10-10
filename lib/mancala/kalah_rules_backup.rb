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

  attr_reader :app, :all_players
  attr_accessor :current_player, :game_over, :extra_turn, :player_1, :player_2

  def initialize(app)
    @app ||= app
    @game_over = false
    @extra_turn = false
    @player_1 ||= create_player(1)
    @player_2 ||= create_player(2)

  end

  def create_player(n)
    return unless n == 1 || 2
    MancalaPlayer.new(n)
  end

  def current_player
    @current_player ||= app.ruler.player_1
  end

  def change_player
    if @current_player == app.ruler.player_1
      @current_player = app.ruler.player_2 unless extra_turn
    elsif @current_player == app.ruler.player_2
      @current_player = app.ruler.player_1 unless extra_turn
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

  def all_players
    @all_players ||= [app.ruler.player_1, app.ruler.player_2]
  end

  def all_empty_on_one_side?
    app.controller.all_empty_pits.all? do |pit|
      player_1_side_pits.include?(pit.id)
    end
    app.controller.all_empty_pits.all? do |pit|
      player_2_side_pits.include?(pit.id)
    end
  end

  def player_1_side_pits
    @player_1_side_pits ||= [1,2,3,4,5,6]
  end

  def player_2_side_pits
    @player_2_side_pits ||= [7,8,9,10,11,12]
  end

  def compare_scores
    if app.controller.player_1_store.count > app.controller.player_1_store.count
      return :player_1_win
    elsif app.controller.player_1_store.count < app.controller.player_1_store.count
      return :player_2_win
    elsif app.controller.player_1_store.count = app.controller.player_1_store.count
      return :tie
    else
      return
    end
  end

  def declare_winner
    if compare_scores == :player_1_win
      @winner = app.ruler.player_1
    elsif compare_scores == :player_2_win
      @winner = app.ruler.player_1
    elsif compare_scores == :tie
      # app.view.print_tie
      return
    else
      return
    end
    app.view.print_winner(@winner)
  end

  def check_and_execute_game_over
    if !all_empty_on_one_side?
      return
    end
    game_over = true
    app.controller.clear_remaining_beads
  end

end
