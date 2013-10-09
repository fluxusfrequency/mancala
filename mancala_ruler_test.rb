gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './mancala.rb'

class MancalaRulerTest < Minitest::Test

  attr_reader :app, :ruler

  def setup
    @app = Mancala.new
    @ruler = app.ruler
  end

  def test_it
  end

end