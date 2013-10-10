gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/mancala/pit.rb'

class PitTest < Minitest::Test
  attr_accessor :pit

  def setup
    @pit ||= MancalaPit.new(1, [285, 350])
  end

  def test_it_should_exist
    refute pit.nil?
  end

  def test_it_has_an_id
    assert_respond_to pit, :id
  end

  def test_it_has_a_location
    assert_respond_to pit, :location
  end

  def test_it_knows_its_x_and_y_coordinates
    assert_respond_to pit, :x
    assert_respond_to pit, :y
  end

  def test_it_has_a_count_accessor_that_defaults_to_4_beads
    assert_respond_to pit, :count
    assert_equal 4, pit.count
    pit.count += 1
    assert_equal 5, pit.count
  end

  def test_it_has_an_empty_method
    refute pit.empty?
  end

end