class MancalaController

  attr_accessor :app

  def initialize(app)
    @app = app
  end

  def take_pit_if_available(coordinates)
    return if coordinates[0] == 0 || coordinates[1] == 0
    found_pit = find_pit_by_coordinates(coordinates)
    player = app.ruler.current_player
    execute_a_take(found_pit.id, player) if app.ruler.legal_pit?(found_pit.id, player)
  end

  def find_pit_by_coordinates(coordinates)
    app.model.all_pits.each do |pit|
      x_range, y_range = (pit.x-75..pit.x+75), (pit.y-75..pit.y+75)
      in_x = x_range.include? coordinates[0]
      in_y = y_range.include? coordinates[1]
      @found = pit if in_x && in_y
    end
    @found
  end

  def execute_a_take(pit_id, player)
    app.ruler.distribute_beads_from(pit_id, player)
    app.ruler.change_player
    app.ruler.extra_turn = false
  end

  def check_for_game_over
    if app.ruler.game_over?
      app.ruler.execute_end_game
    end
  end

end
