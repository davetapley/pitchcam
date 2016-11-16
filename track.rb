require_relative 'segment'

class Track
  attr_reader :segments, :car_radius_world

  CARD_RADIUS_TRACK = 0.8

  def initialize(world_transform)
    @car_radius_world = CARD_RADIUS_TRACK * world_transform.scale

    start_origin = world_transform.origin
    @segments = [Segment.new(0, start_origin, world_transform)]
    prev_segment = segments.first

    1.times.each_with_index do |index|
      origin = prev_segment.next_world_origin
      segments << Segment.new(index + 1, origin, world_transform)
    end
  end

  def inside?(point)
    segments.any? { |segment| segment.inside? point }
  end

  def render(canvas)
    segments.each { |segment| segment.render canvas }
  end

  def position_from_world(point)
    index = segments.find_index { |segment| segment.inside? point }
    return nil unless index

    segment_progress, drift = segments[index].position_from_world point
    progress = index + segment_progress

    [progress, drift]
  end
end
