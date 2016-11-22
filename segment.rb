require_relative 'straight'
require_relative 'corner'

class Segment

  attr_reader  :index, :world_origin, :world_transform, :tile, :bottom_left_world

  def initialize(index, world_origin, world_transform, tile_class)
    @index = index
    @world_origin = world_origin
    @world_transform = world_transform
    @tile = tile_class.new
  end


  def render_outline_to(canvas)
    render_to canvas, tile.outline

    label_position = CvPoint.new world_origin.x, world_origin.y + 25
    canvas.put_text!(index.to_s, label_position, CvFont.new(:simplex), CvColor::White)
  end

  def render_progress_to(canvas, color, position)
    render_to canvas, tile.progress_line(position.p), color
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
    local_to_world tile.local_from_position(position)
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

  def render_to(canvas, shapes, color = CvColor::White)
    shapes.each do |type, *points|
      from = local_to_world points[0]
      to = local_to_world points[1]

      case type
      when :line
        canvas.line! from, to, thickness: 1, color: color
      when :arc
        origin = local_to_world points[2]
        axes = CvSize.new (from.x - to.x).abs, (from.y - to.y).abs
        angle = 0
        canvas.ellipse! origin, axes, angle, 0, 90, thickness: 1, color: color
      else
        raise "Can't render #{type}"
      end

    end
  end
end
