gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '.mancala.rb'

class MancalaModelTest < Minitest::Test

  attr_reader :app

  def setup
    @app = Mancala.new
  end

  def test_it
  end

end