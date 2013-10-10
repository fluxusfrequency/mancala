gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/mancala/player.rb'

class Mancala

  attr_reader :controller
  attr_accessor :ruler

  def initialize
    @controller = MancalaController.new(self)
  end

end

class PitTest < Minitest::Test
  attr_accessor :app, :controller

  def setup
    @app ||= Mancala.new
    @controller ||= app.controller
  end

  def test_it_should_exist
    refute controller.nil?
  end

  def test_it_can_distribute_the_beads_when_a_player_chooses_a_pit

  end

end