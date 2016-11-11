class Car
  RADIUS = 0.08

  attr_reader :name, :positions

  def initialize(name)
    @name = name
    @positions = []
  end

  def update_world_position(point)
    positions << point if positions.empty?

    delta = Math.sqrt((latest_world_position.x - point.x).abs + (latest_world_position.y - point.y).abs)

    return unless delta > 2
    positions << point
  end

  def latest_world_position
    positions.last
  end
end
