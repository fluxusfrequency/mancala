gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './mancala.rb'

class MancalaModelTest < Minitest::Test

  attr_reader :app, :model

  def setup
    @app = Mancala.new
    @model = app.model
  end

  def test_it_exists
    refute app.model.nil?
  end

end