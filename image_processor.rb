class ImageProcessor

  attr_reader :track, :source_window, :colors_attrs, :colors_windows, :colors_world_positions, :colors_track_positions

  def initialize(track, source_window, colors_attrs, colors_windows)
    @track = track
    @source_window = source_window
    @colors_attrs = colors_attrs
    @colors_windows = colors_windows || {}

    colors = colors_attrs.keys
    @colors_world_positions = Hash[colors.map { |color| [color, nil] }]
    @colors_track_positions = Hash[colors.map { |color| [color, nil] }]
  end

  def handle_image(image)
    result = image.clone
    hsv = image.BGR2HSV

    dirty_colors = []

    colors_attrs.each do |color, color_attrs|
      color_map = hsv.in_range(color_attrs[:low], color_attrs[:high]).dilate(nil, 2)
      color_window = colors_windows[color]

      if color_window
        color_window.show color_map
      else
        hough = color_map.hough_circles CV_HOUGH_GRADIENT, 2, 5, 200, 40
        hough = hough.to_a.reject { |circle| circle.radius > track.car_radius_world * 1.5 }
        if hough.size > 0
          circle = hough.first
          new_world_position = circle.center

          on_track = track.inside? circle.center
          if on_track
            previous_world_position = colors_world_positions[color]
            new_track_position = track.position_from_world new_world_position

            if previous_world_position.nil?
              dirty_colors << [color, new_track_position]
            else
              delta_x = (new_world_position.x - previous_world_position.x).abs
              delta_y = (new_world_position.y - previous_world_position.y).abs
              delta = Math.sqrt(delta_x + delta_y)
              dirty_colors << [color, new_track_position] if delta > 4
            end

            cv_color = CvColor::const_get color.capitalize
            result.circle! new_world_position, track.car_radius_world, thickness: 3, color: cv_color
          else
            previous_track_position = colors_track_positions[color]
            dirty_colors << [color, nil] unless previous_track_position.nil?
            result.circle! new_world_position, track.car_radius_world, thickness: 1, color: cv_color
          end
        end
      end
    end

    track.render result
    source_window.show result

    dirty_colors
  end
end
