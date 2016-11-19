Segment = Struct.new :index, :world_origin, :world_transform do
  WIDTH = 0.63
  def render_to(canvas)
    p0 = CvPoint2D32f.new 0, 0
    p1 = CvPoint2D32f.new WIDTH, 0
    p2 = CvPoint2D32f.new WIDTH, 1
    p3 = CvPoint2D32f.new 0, 1
    [[p0, p1], [p1, p2], [p2, p3], [p3, p0]].each do |from, to|
      canvas.line! local_to_world(from), local_to_world(to), thickness: 1, color:CvColor::White
    end
    canvas.put_text!(index.to_s, local_to_world(p3), CvFont.new(:simplex), CvColor::White)
  end

  def inside?(point)
    local_point = world_to_local point

    return unless 0 < local_point.x && local_point.x < 0.7
    0 < local_point.y && local_point.y < 1
  end

  def next_world_origin
    p = CvPoint2D32f.new 0, 1
    local_to_world p
  end

  def position_from_world(point)
    local_point = world_to_local point
    p = local_point.y # progress
    d = local_point.x / WIDTH # drift
    Track::Postition.new p, d
  end

  def world_from_position(position)
    local_point = CvPoint2D32f.new (position.d * WIDTH), position.p
    local_to_world local_point
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
