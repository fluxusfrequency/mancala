require 'ruby-processing'

class MancalaPitController
  attr_reader :app
  attr_accessor :pit1,
                :pit2,
                :pit3,
                :pit4,
                :pit5,
                :pit6,
                :pit7,
                :pit8,
                :pit9,
                :pit10,
                :pit11,
                :pit12

  def initialize(app)
    @app = app
    setup_pits
    setup_stores
  end

  def location_for_number_of_pieces(n)
    case n
    when 1 then [[x, y]]
    when 2 then [[x-37, y] [x+37, y]]
    when 3 then [[x, y+37], [x-37, y-37], [x-37, y+37]]
    when 4 then [[x-37, y-37], [x+37, y-37], [x-37, y+37], [x+37, y+37]]
    else
      [[]]
    end
  end

  def all
    @all ||= [pit1,
              pit2,
              pit3,
              pit4,
              pit5,
              pit6,
              pit7,
              pit8,
              pit9,
              pit10,
              pit11,
              pit12]
  end

  def setup_pits
    @pit1 = MancalaPit.new([285, 350])
    @pit2 = MancalaPit.new([455, 350])
    @pit3 = MancalaPit.new([625, 350])
    @pit4 = MancalaPit.new([795, 350])
    @pit5 = MancalaPit.new([965, 350])
    @pit6 = MancalaPit.new([1135, 350])
    @pit7 = MancalaPit.new([1135, 150])
    @pit8 = MancalaPit.new([965, 150])
    @pit9 = MancalaPit.new([795, 150])
    @pit10 = MancalaPit.new([625, 150])
    @pit11 = MancalaPit.new([455, 150])
    @pit12 = MancalaPit.new([285, 150])
  end

  def setup_stores
    @player_one_store = MancalaStore.new(115)
    @player_two_store = MancalaStore.new(1305)
  end

  def return_attribues_for_pit(n)
    pit"#{n}".attributes_for_build
  end

end

class MancalaPit
  attr_reader :location, :x, :y, :count

  def initialize(location)
    @location = location
    @x = location[0]
    @y = location[1]
    @count ||= 4
  end

end

class MancalaStore
  attr_reader :count

  def initialize(location)
    @count ||= 0
  end

end

class MancalaBoardView

  attr_reader :app

  def initialize(app)
    @app ||= app
  end

  def draw_board
    app.fill 106
    app.stroke 0
    app.rect 20, 55, 1385, 400
    app.stroke 206
    app.fill 256, 256, 256
    app.rect 20, 50, 1385, 400
    draw_title

    app.stroke 0
    app.fill 225
    draw_pits
    draw_stores
  end

  def draw_pits
    app.pit_controller.all.each do |pit|
      app.ellipse pit.x, pit.y, 150, 150
    end

    # app.ellipse 285, 150, 150, 150
    # app.ellipse 285, 350, 150, 150
    # app.ellipse 455, 150, 150, 150
    # app.ellipse 455, 350, 150, 150
    # app.ellipse 625, 150, 150, 150
    # app.ellipse 625, 350, 150, 150
    # app.ellipse 795, 150, 150, 150
    # app.ellipse 795, 350, 150, 150
    # app.ellipse 965, 150, 150, 150
    # app.ellipse 965, 350, 150, 150
    # app.ellipse 1135, 150, 150, 150
    # app.ellipse 1135, 350, 150, 150
  end

  def draw_stores
    app.ellipse 115, 250, 150, 350
    app.ellipse 1305, 250, 150, 350
  end

  def draw_title
    app.text "MANCALA", 628, 25
  end

end

class MancalaGameView
  attr_reader :app
  attr_accessor :random_colors

  def initialize(app)
    @app ||= app
    @random_colors ||= []
    build_random_colors
  end

  def build_random_colors
    48.times do
      random_colors << [rand(256), rand(256), rand(256)]
    end
  end

  def fill_a_random_color(num)
    puts "random_colors"
    app.fill(random_colors[num][0], random_colors[num][1], random_colors[num][2])
  end

  def draw_game
    fill_a_random_color(0)
    app.ellipse 260, 125, 25, 25
    fill_a_random_color(1)
    app.ellipse 310, 125, 25, 25
    fill_a_random_color(2)
    app.ellipse 260, 175, 25, 25
    fill_a_random_color(3)
    app.ellipse 310, 175, 25, 25

    fill_a_random_color(4)
    app.ellipse 430, 125, 25, 25
    fill_a_random_color(5)
    app.ellipse 480, 125, 25, 25
    fill_a_random_color(6)
    app.ellipse 430, 175, 25, 25
    fill_a_random_color(7)
    app.ellipse 480, 175, 25, 25

    fill_a_random_color(8)
    app.ellipse 600, 125, 25, 25
    fill_a_random_color(9)
    app.ellipse 650, 125, 25, 25
    fill_a_random_color(10)
    app.ellipse 600, 175, 25, 25
    fill_a_random_color(11)
    app.ellipse 650, 175, 25, 25

    fill_a_random_color(12)
    app.ellipse 770, 125, 25, 25
    fill_a_random_color(13)
    app.ellipse 820, 125, 25, 25
    fill_a_random_color(14)
    app.ellipse 770, 175, 25, 25
    fill_a_random_color(15)
    app.ellipse 820, 175, 25, 25

    fill_a_random_color(16)
    app.ellipse 940, 125, 25, 25
    fill_a_random_color(17)
    app.ellipse 990, 125, 25, 25
    fill_a_random_color(18)
    app.ellipse 940, 175, 25, 25
    fill_a_random_color(19)
    app.ellipse 990, 175, 25, 25

    fill_a_random_color(20)
    app.ellipse 1110, 125, 25, 25
    fill_a_random_color(21)
    app.ellipse 1160, 125, 25, 25
    fill_a_random_color(22)
    app.ellipse 1110, 175, 25, 25
    fill_a_random_color(23)
    app.ellipse 1160, 175, 25, 25

    fill_a_random_color(24)
    app.ellipse 260, 325, 25, 25
    fill_a_random_color(25)
    app.ellipse 310, 325, 25, 25
    fill_a_random_color(26)
    app.ellipse 260, 375, 25, 25
    fill_a_random_color(27)
    app.ellipse 310, 375, 25, 25

    fill_a_random_color(28)
    app.ellipse 430, 325, 25, 25
    fill_a_random_color(29)
    app.ellipse 480, 325, 25, 25
    fill_a_random_color(30)
    app.ellipse 430, 375, 25, 25
    fill_a_random_color(31)
    app.ellipse 480, 375, 25, 25

    fill_a_random_color(32)
    app.ellipse 600, 325, 25, 25
    fill_a_random_color(33)
    app.ellipse 650, 325, 25, 25
    fill_a_random_color(34)
    app.ellipse 600, 375, 25, 25
    fill_a_random_color(35)
    app.ellipse 650, 375, 25, 25

    fill_a_random_color(36)
    app.ellipse 770, 325, 25, 25
    fill_a_random_color(37)
    app.ellipse 820, 325, 25, 25
    fill_a_random_color(38)
    app.ellipse 770, 375, 25, 25
    fill_a_random_color(39)
    app.ellipse 820, 375, 25, 25

    fill_a_random_color(40)
    app.ellipse 940, 325, 25, 25
    fill_a_random_color(41)
    app.ellipse 990, 325, 25, 25
    fill_a_random_color(42)
    app.ellipse 940, 375, 25, 25
    fill_a_random_color(43)
    app.ellipse 990, 375, 25, 25

    fill_a_random_color(44)
    app.ellipse 1110, 325, 25, 25
    fill_a_random_color(45)
    app.ellipse 1160, 325, 25, 25
    fill_a_random_color(46)
    app.ellipse 1110, 375, 25, 25
    fill_a_random_color(47)
    app.ellipse 1160, 375, 25, 25
  end

end

class MancalaModel
  attr_reader :app

  def initialize(app)
    @app ||= app
    @current_player = 'x'
    @game_over = false
  end

end

class MancalaKalahRules
  attr_reader :app

  def initialize(app)
    @app ||= app
    # @current_player = :player_1
    # @game_over = false
  end

  # def change_player
  #   if @current_player == :player_1
  #     @current_player = :player_2
  #   else
  #     @current_player = :player_1
  #   end
  # end

end



class Mancala < Processing::App

  attr_reader :board, :view, :model, :pit_controller, :ruler

  def setup
    size 1425, 500
    background 0
    @pit_controller = MancalaPitController.new(self)
    @board = MancalaBoardView.new(self)
    @view = MancalaGameView.new(self)
    @model = MancalaModel.new(self)
    @ruler = MancalaKalahRules.new(self)
  end

  def draw
    board.draw_board
    view.draw_game
  end

end

Mancala.new