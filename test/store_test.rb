gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/mancala/store.rb'

class StoreTest < Minitest::Test
  attr_accessor :store

  def setup
    @store ||= MancalaStore.new(1)
  end

  def test_it_should_exist
    refute store.nil?
  end

  def test_it_has_an_id
    assert_respond_to store, :id
  end

  def test_it_has_a_count_accessor_that_defaults_to_4_beads
    assert_respond_to store, :count
    assert_equal 0, store.count
    store.count += 1
    assert_equal 1, store.count
  end

  def test_it_has_an_empty_method
    assert store.empty?
  end

end