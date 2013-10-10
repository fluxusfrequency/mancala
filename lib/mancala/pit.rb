class MancalaPit

  # What is my id?
  # What are my coordinates?
  # How many pieces do I currently contain?
  # Am I empty?

  attr_reader :id, :location, :x, :y
  attr_accessor :count

  def initialize(id, location)
    @id = id
    @location = location
    @x = location[0]
    @y = location[1]
    @count ||= 4
  end

  def empty?
    count == 0
  end

end
