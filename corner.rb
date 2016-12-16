class Corner
<<<<<<< HEAD
  # Turning from y = 1 to x = 1
  def inside?(point)
    return unless 0 < point.x && point.x < 1 && 0 < point.y && point.y < 1
    (point.x - 1) ** 2 + (point.y - 1) ** 2 < 4
  end

  def next_world_origin
    CvPoint2D32f.new 1, 1
=======
  WIDTH = 1
  EDGE = 1.3
  INNER_RADIUS = EDGE - WIDTH
  X_LOW = WIDTH - EDGE

  # Turning from y = 0 to x = 0

  def inside?(point)
    # Inside bounding square?
    return false unless X_LOW < point.x && point.x < EDGE && 0 < point.y && point.y < EDGE

    # And inside outer circle?
    return false unless inside_circle? point, EDGE

    # But not inside inner circle?
    return false if inside_circle? point, INNER_RADIUS

    true
  end

  def next_local_origin
    CvPoint2D32f.new X_LOW, INNER_RADIUS
  end

  def next_angle
    -(Math::PI / 2.0)
>>>>>>> b619084780a2ec761676ed8bc0ce34a01950e2aa
  end

  def position_from_local(point)
    # http://stackoverflow.com/a/839931/21115
<<<<<<< HEAD
    p = point.y # progress
    d = point.x / WIDTH # drift
=======
    angle = Math.atan2 (point.x + INNER_RADIUS), point.y
    p = 1 - (angle / (Math::PI / 2.0)) # progress

    d_x = INNER_RADIUS + point.x
    d_y = point.y
    d_h = Math.sqrt(d_x**2 + d_y**2) - INNER_RADIUS
    d =  d_h / WIDTH

>>>>>>> b619084780a2ec761676ed8bc0ce34a01950e2aa
    Track::Postition.new p, d
  end

  def local_from_position(position)
    # http://stackoverflow.com/a/839931/21115
<<<<<<< HEAD
    CvPoint2D32f.new (position.d * WIDTH), position.p
  end

  def outline
=======
    angle = (position.p) * (Math::PI / 2.0)
    d_x = Math.cos angle
    d_y = Math.sin angle

    r = INNER_RADIUS + (position.d * WIDTH)
    x = X_LOW + (r * d_x)
    y = r * d_y

    CvPoint2D32f.new x, y
  end

  def outline
    p0 = CvPoint2D32f.new 0, 0
    p1 = CvPoint2D32f.new WIDTH, 0
    p2 = CvPoint2D32f.new X_LOW, EDGE
    p3 = CvPoint2D32f.new X_LOW, INNER_RADIUS

    pO = CvPoint2D32f.new X_LOW, 0

    [
      [:line, p0, p1],
      [:line, p2, p3],
      [:arc, p1, pO,  INNER_RADIUS + WIDTH], # outer
      [:arc, p0, pO, INNER_RADIUS]  # inner
    ]
  end

  def progress_line(progress)
    angle = progress * (Math::PI / 2.0)

    d_x = Math.cos angle
    d_y = Math.sin angle

    p0 = CvPoint2D32f.new X_LOW + (d_x * INNER_RADIUS), d_y * INNER_RADIUS
    p1 = CvPoint2D32f.new X_LOW + (d_x * EDGE), d_y * EDGE
    [[:line, p0, p1]]
  end

  private

  def inside_circle?(point, radius)
    (point.x - X_LOW)**2 + (point.y - 0)**2 < radius**2
>>>>>>> b619084780a2ec761676ed8bc0ce34a01950e2aa
  end
end

