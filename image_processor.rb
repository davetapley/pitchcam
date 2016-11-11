ImageProcessor = Struct.new :world_transform, :colors, :track, :source_window do

  def handle_image(image)
    car_radius_world = Car::RADIUS * world_transform.scale

    result = image.clone

    hsv = image.BGR2HSV

    colors.each do |color, color_attrs|
      color_map = hsv.in_range(color_attrs[:low], color_attrs[:high]).dilate(nil, 2)

      color_window = color_attrs[:window]

      if color_window
        color_window.show color_map
      else
        car = color_attrs[:car]
        cv_color = CvColor::const_get color.capitalize

        hough = color_map.hough_circles CV_HOUGH_GRADIENT, 2, 5, 200, 40
        hough = hough.to_a.reject { |circle| circle.radius > car_radius_world * 1.5 }
        if hough.size > 0
          circle = hough.first

          result.circle! circle.center, circle.radius, thickness: 1, color: cv_color

          on_track = track.inside? circle.center
          car.update_world_position circle.center if on_track
        end

        unless car.latest_world_position.nil?
          result.circle! car.latest_world_position, car_radius_world, thickness: 3, color: cv_color
        end
      end
    end

    track.render result

    source_window.show result
  end
end
