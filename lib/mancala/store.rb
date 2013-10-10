class MancalaStore

  # How many pieces do I currently contain?
  # Am I empty?
  # Which player do I belong to?

  attr_reader :id
  attr_accessor :count

  def initialize(id)
    @id = id
    @count ||= 0
  end

  def empty?
    count == 0
  end

end
