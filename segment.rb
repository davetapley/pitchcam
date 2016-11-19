class Segment

  attr_reader  :index, :world_origin, :world_transform, :tile, :bottom_left_world

  def initialize(index, world_origin, world_transform)
    @index = index
    @world_origin = world_origin
    @world_transform = world_transform
    @tile = Straight.new
    @bottom_left_world = CvPoint2D32f.new 0, 1
  end

  def render_to(canvas)
    tile.outline.each do |type, *points|
      case type
      when :line
        from = local_to_world points.first
        to = local_to_world points.last
        canvas.line! from, to, thickness: 1, color:CvColor::White
      else
        raise "Can't render #{type}"
      end

    end
    canvas.put_text!(index.to_s, bottom_left_world, CvFont.new(:simplex), CvColor::White)
  end

  def inside?(point)
    local_point = world_to_local point
    tile.inside? local_point
  end

  def next_world_origin
    local_to_world tile.next_world_origin
  end

  def position_from_world(point)
    local_point = world_to_local point
    tile.position_from_local local_point
  end

  def world_from_position(position)
    local_to_world tile.local_from_position(postition)
  end

  private

  def world_to_local(point)
    world_scale = world_transform.scale
    x = (point.x - world_origin.x) / world_scale
    y = (point.y - world_origin.y) / world_scale
    CvPoint2D32f.new x, y
  end

  def local_to_world(point)
    world_scale = world_transform.scale
    x = (point.x * world_scale) + world_origin.x
    y = (point.y * world_scale) + world_origin.y
    CvPoint.new x, y
  end
end
