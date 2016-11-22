require_relative 'segment'

class Track
  Postition = Struct.new :p, :d do
    def segment_index
      p.floor
    end

    def to_segment_local
      Postition.new p.modulo(1), d
    end

    def to_track_at(index)
      Postition.new (index + p), d
    end

    def to_local
      Postition.new (p % 1), d
    end

    def to_s
      "#{segment_index}\t#{to_local.p.round 2}\t#{d.round 2}"
    end
  end

  attr_reader :segments, :car_radius_world

  CAR_RADIUS_TRACK = 0.1

  def initialize(world_transform)
    @car_radius_world = CAR_RADIUS_TRACK * world_transform.scale

    start_origin = world_transform.origin
    @segments = [Segment.new(0, start_origin, world_transform, Straight)]
    prev_segment = segments.first

    1.times.each_with_index do |index|
      origin = prev_segment.next_world_origin
      segments << Segment.new(index + 1, origin, world_transform, Corner)
    end
  end

  def inside?(point)
    segments.any? { |segment| segment.inside? point }
  end

  def render_outline_to(canvas)
    segments.each { |segment| segment.render_outline_to canvas }
  end

  def render_progress_to(canvas, color, position)
    segment = segments[position.segment_index]
    segment.render_progress_to canvas, color, position.to_local
  end

  def position_from_world(point)
    index = segments.find_index { |segment| segment.inside? point }
    return nil unless index

    segment_position = segments[index].position_from_world point
    raise "Segment progress should never be above 1" if segment_position.p >= 1
    segment_position.to_track_at index
  end

  def world_from_position(position)
    segment = segments[position.segment_index]
    segment.world_from_position position.to_segment_local
  end
end
