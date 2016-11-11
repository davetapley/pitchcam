module DevUI
  def add_color_windows(colors)
    colors.each do |color, attrs|
      color_window = GUI::Window.new color

      color_window.set_trackbar("h low", 255, attrs[:low][0])  { |v| attrs[:low][0] = v }
      color_window.set_trackbar("h high", 255, attrs[:high][0]) { |v| attrs[:high][0] = v }

      color_window.set_trackbar("s low", 255, attrs[:low][1]) { |v| attrs[:low][1] = v }
      color_window.set_trackbar("s high", 255, attrs[:high][1]) { |v| attrs[:high][1] = v }

      color_window.set_trackbar("v low", 255, attrs[:low][2]) { |v| attrs[:low][2] = v }
      color_window.set_trackbar("v high", 255, attrs[:high][2]) { |v| attrs[:high][2] = v }

      attrs[:window] = color_window
    end
  end


  def add_world_transform_trackbars(source_window)
    source_window.set_trackbar("origin x", 640, start_origin.x)  { |v| start_origin.x = v }
    source_window.set_trackbar("origin y", 640, start_origin.y)  { |v| start_origin.y = v }
    source_window.set_trackbar("scale", 200, world_transform.scale)  { |v| world_transform.scale = v }
  end
end
