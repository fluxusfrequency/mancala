class MancalaPlayer

  # Which pits can I move from?
  # Which store is mine?
  # How many beads are in my store?

  attr_reader :id

  def initialize(id)
    @id = id
  end

  def my_pit_ids
    if id == 1
      return [1, 2, 3, 4, 5, 6]
    elsif id == 2
      return [7, 8, 9, 10, 11, 12]
    else
      return []
    end
  end

  def my_store_id
    id
  end

end