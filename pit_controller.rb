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

  def has_turn?(player)
    player == current_player
  end

  def valid_pits_for_player(player)
    [1, 2, 3, 4, 5, 6] if player.id == 1
    [7, 8, 9, 10, 11 12] if player.id == 2
  end

end
