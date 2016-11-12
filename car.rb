class Car
  RADIUS = 0.08

  attr_reader :name, :positions

  def initialize(name)
    @name = name
    @positions = []
  end

  def update_world_position(point)
    return new_world_position! point if positions.empty?

    delta = Math.sqrt((latest_world_position.x - point.x).abs + (latest_world_position.y - point.y).abs)
    return new_world_position! point if delta > 4
    false
  end

  def latest_world_position
    positions.last
  end

  private

  def new_world_position!(point)
    positions << point
    true
  end
end
