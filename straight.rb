class Straight
  # Longest side in y axis

  WIDTH = 0.63

  def inside?(point)
    0 < point.x && point.x < 0.7 && 0 < point.y && point.y < 1
  end

  def next_world_origin
    CvPoint2D32f.new 0, 1
  end

  def position_from_local(point)
    p = point.y # progress
    d = point.x / WIDTH # drift
    Track::Postition.new p, d
  end

  def local_from_position(position)
    CvPoint2D32f.new (position.d * WIDTH), position.p
  end

  def outline
    p0 = CvPoint2D32f.new 0, 0
    p1 = CvPoint2D32f.new WIDTH, 0
    p2 = CvPoint2D32f.new WIDTH, 1
    p3 = CvPoint2D32f.new 0, 1
    [
      [:line, p0, p1],
      [:line, p1, p2],
      [:line, p2, p3],
      [:line, p3, p0]
    ]
  end
end
