class Corner
  # Turning from y = 1 to x = 1
  def inside?(point)
    return unless 0 < point.x && point.x < 1 && 0 < point.y && point.y < 1
    (point.x - 1) ** 2 + (point.y - 1) ** 2 < 4
  end

  def next_world_origin
    CvPoint2D32f.new 1, 1
  end

  def position_from_local(point)
    # http://stackoverflow.com/a/839931/21115
    p = point.y # progress
    d = point.x / WIDTH # drift
    Track::Postition.new p, d
  end

  def local_from_position(position)
    # http://stackoverflow.com/a/839931/21115
    CvPoint2D32f.new (position.d * WIDTH), position.p
  end

  def outline
  end
end

