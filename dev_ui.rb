require_relative 'color'

module DevUI
  module ColorExtensions
    def window
      @window ||= GUI::Window.new(name).tap do |window|
        window.set_trackbar("h low", 255, hsv_low[0])  { |v| hsv_low[0] = v }
        window.set_trackbar("h high", 255, hsv_high[0]) { |v| hsv_high[0] = v }

        window.set_trackbar("s low", 255, hsv_low[1]) { |v| hsv_low[1] = v }
        window.set_trackbar("s high", 255, hsv_high[1]) { |v| hsv_high[1] = v }

        window.set_trackbar("v low", 255, hsv_low[2]) { |v| hsv_low[2] = v }
        window.set_trackbar("v high", 255, hsv_high[2]) { |v| hsv_high[2] = v }
      end
    end
  end

  Color.include ColorExtensions

  def add_world_transform_trackbars(window, world_transform)
    origin = world_transform.origin
    window.set_trackbar("origin x", 640, origin.x)  { |v| origin.x = v }
    window.set_trackbar("origin y", 640, origin.y)  { |v| origin.y = v }
    window.set_trackbar("scale", 200, world_transform.scale)  { |v| world_transform.scale = v }
  end

  def render_dev_overlay(race, window, image, dirty_colors, colors, color_window_on)
    track = race.track

    result = image.clone

    race.colors_entrants.each do |color, entrant|
      next unless entrant.on_track?
      cv_color = CvColor::const_get color.capitalize
      thickness = entrant.is_turn ? 3 : 1
      world_position = track.world_from_position entrant.track_position
      result.circle! world_position, track.car_radius_world, thickness: thickness, color: cv_color
    end

    if color_window_on
      colors.each do |color|
        color.window.show color.map(image)
      end
    end

    track.render_to result
    window.show result
  end
end
