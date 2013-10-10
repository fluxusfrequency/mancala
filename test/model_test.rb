gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/mancala/model.rb'
require './lib/mancala/pit.rb'
require './lib/mancala/store.rb'
require './lib/mancala/player.rb'

class Mancala

  attr_reader :model, :controller
  attr_accessor :ruler

  def initialize
    @model = MancalaModel.new(self)
  end

end

class ModelTest < Minitest::Test
  attr_accessor :app, :model

  def setup
    @app ||= Mancala.new
    @model ||= app.model
  end

  def test_it_should_exist
    refute model.nil?
  end

  def test_it_sets_up_pits_and_stores_when_created
    assert_kind_of MancalaPit, model.all_pits.first
    assert_kind_of MancalaStore, model.all_stores.first
  end

  def test_it_can_find_a_pit_by_id
    assert_equal 1, model.find_pit_by_id(1).id
  end

  def test_it_can_find_a_store_by_id
    assert_equal 1, model.find_store_by_id(1).id
  end

  def test_it_knows_how_many_pieces_are_in_each_pit
    model.pit1.count += 1
    assert_equal 5, model.pit_counts.keys.first
    assert_equal 4, model.pit_counts.keys.last
  end

  def test_it_knows_how_many_pieces_are_in_each_store
    model.store1.count += 1
    assert_equal 1, model.store_counts.keys.first
    assert_equal 0, model.store_counts.keys.last
  end

  def test_it_can_find_all_pits_with_a_given_count
    model.pit1.count = 0
    assert_equal 1, model.find_all_pits_by_count(0).first.id
    assert_equal 11, model.find_all_pits_by_count(4).length
  end

  def test_it_can_add_or_remove_a_bead_from_a_pit
    model.add_bead_to_pit(1)
    assert_equal 5, model.pit1.count
    model.remove_bead_from_pit(2)
    assert_equal 3, model.pit2.count
  end

  def test_it_can_add_a_bead_to_a_store
    model.add_bead_to_store(1)
    assert_equal 1, model.store1.count
  end

  def test_it_can_empty_a_pit
    model.empty_pit(1)
    assert model.pit1.empty?
  end

  def test_it_can_find_the_id_of_the_next_pit
    assert_equal 2, model.find_next_pit_by_id(1)
    assert_equal 1, model.find_next_pit_by_id(12)
  end

  def test_it_can_return_the_opposite_pit
    assert_equal 11, model.find_opposite_pit_by_id(2).id
  end

  def test_it_can_tell_if_player_one_side_is_empty
    model.empty_pit(1)
    model.empty_pit(2)
    model.empty_pit(3)
    model.empty_pit(4)
    model.empty_pit(5)
    model.empty_pit(6)
    assert model.all_empty_on_one_side?
    model.find_pit_by_id(1).count = 1
    refute model.all_empty_on_one_side?
  end

  def test_it_can_tell_if_player_one_side_is_empty
    model.empty_pit(7)
    model.empty_pit(8)
    model.empty_pit(9)
    model.empty_pit(10)
    model.empty_pit(11)
    model.empty_pit(12)
    assert model.all_empty_on_one_side?
    model.find_pit_by_id(8).count = 1
    refute model.all_empty_on_one_side?
  end

end