gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/mancala/player.rb'
require './lib/mancala/pit.rb'
require './lib/mancala/store.rb'
require './lib/mancala/model.rb'
require './lib/mancala/kalah_rules.rb'

class Mancala
  attr_accessor :ruler, :model, :controller

  def initialize
    @ruler = MancalaKalahRules.new(self)
    @model = MancalaModel.new(self)
  end

end

class RulerTest < Minitest::Test

  attr_accessor :app, :ruler, :model

  def setup
    @app ||= Mancala.new
    @ruler ||= app.ruler
    @model ||= ruler.app.model
  end

  def test_it_should_exist
    refute ruler.nil?
  end

  def test_it_sets_up_players
    assert_respond_to ruler, :player_1
    assert_respond_to ruler, :player_2
  end

  def test_it_knows_who_the_current_player_is
    assert 1, ruler.current_player.id
  end

  def test_it_can_change_the_current_player
    ruler.change_player
    assert 2, ruler.current_player.id
  end

  def test_it_knows_which_pits_are_legal_for_each_player
    assert ruler.legal_pit?(1, ruler.player_1)
    assert ruler.legal_pit?(2, ruler.player_1)
    assert ruler.legal_pit?(3, ruler.player_1)
    assert ruler.legal_pit?(4, ruler.player_1)
    assert ruler.legal_pit?(5, ruler.player_1)
    assert ruler.legal_pit?(6, ruler.player_1)
    assert ruler.legal_pit?(7, ruler.player_2)
    assert ruler.legal_pit?(8, ruler.player_2)
    assert ruler.legal_pit?(9, ruler.player_2)
    assert ruler.legal_pit?(10, ruler.player_2)
    assert ruler.legal_pit?(11, ruler.player_2)
    assert ruler.legal_pit?(12, ruler.player_2)
    refute ruler.legal_pit?(1, ruler.player_2)
    refute ruler.legal_pit?(2, ruler.player_2)
    refute ruler.legal_pit?(3, ruler.player_2)
    refute ruler.legal_pit?(4, ruler.player_2)
    refute ruler.legal_pit?(5, ruler.player_2)
    refute ruler.legal_pit?(6, ruler.player_2)
    refute ruler.legal_pit?(7, ruler.player_1)
    refute ruler.legal_pit?(8, ruler.player_1)
    refute ruler.legal_pit?(9, ruler.player_1)
    refute ruler.legal_pit?(10, ruler.player_1)
    refute ruler.legal_pit?(11, ruler.player_1)
    refute ruler.legal_pit?(12, ruler.player_1)
  end

  def test_it_doesnt_allow_empty_pits_to_be_chosen
    model.empty_pit(1)
    refute ruler.legal_pit?(1, ruler.player_1)
    model.empty_pit(7)
    refute ruler.legal_pit?(7, ruler.player_2)
  end

  def test_it_can_distribute_beads_chosen_during_a_move
    ruler.distribute_beads_from(1, ruler.player_1)
    assert_equal 4, model.pit_counts[5].count
    assert_equal 5, model.find_pit_count_by_id(2)
    assert_equal 5, model.find_pit_count_by_id(3)
    assert_equal 5, model.find_pit_count_by_id(4)
    assert_equal 5, model.find_pit_count_by_id(5)
  end

  def test_distributes_beads_into_player_one_store
    ruler.distribute_beads_from(4, ruler.player_1)
    assert_equal 3, model.pit_counts[5].count
    assert_equal 5, model.find_pit_count_by_id(5)
    assert_equal 5, model.find_pit_count_by_id(6)
    assert_equal 5, model.find_pit_count_by_id(7)
    assert_equal 4, model.find_pit_count_by_id(8)
    assert_equal 1, model.find_store_by_id(1).count
  end

  def test_distributes_beads_into_player_two_store
    ruler.distribute_beads_from(9, ruler.player_2)
    assert_equal 3, model.pit_counts[5].count
    assert_equal 5, model.find_pit_count_by_id(10)
    assert_equal 5, model.find_pit_count_by_id(11)
    assert_equal 5, model.find_pit_count_by_id(12)
    assert_equal 4, model.find_pit_count_by_id(1)
    assert_equal 1, model.find_store_by_id(2).count
  end

  def test_it_gives_the_current_player_another_turn_if_she_lands_on_her_store
    starting_player = ruler.current_player
    ruler.distribute_beads_from(3, ruler.player_1)
    ruler.change_player
    assert_equal starting_player, ruler.current_player
  end

  def test_it_doesnt_give_another_turn_if_she_passes_her_store
    starting_player = ruler.current_player
    ruler.distribute_beads_from(4, ruler.player_1)
    ruler.change_player
    refute_equal starting_player, ruler.current_player
  end

  def test_it_takes_the_last_bead_and_opponents_beads_when_landing_on_an_empty_pit_on_the_players_side
    model.find_pit_by_id(5).count = 0
    ruler.distribute_beads_from(1, ruler.player_1)
    assert_equal 0, model.find_pit_count_by_id(8)
    assert_equal 5, ruler.current_players_store.count
  end

  def test_it_knows_when_the_game_ends
    model.empty_pit(1)
    model.empty_pit(2)
    model.empty_pit(3)
    model.empty_pit(4)
    model.empty_pit(5)
    model.empty_pit(6)
    model.all_empty_on_one_side?
    assert ruler.game_over?
  end

  # def test_it_gives_remaining_beads_to_player_on_game_over
  #   ruler.execute_end_game
  # end

  end


end