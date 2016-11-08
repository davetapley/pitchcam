#!/usr/bin/env ruby
# convexhull.rb
# Draw contours and convexity defect points to captured image
require "rubygems"
require "opencv"
require 'yaml'
require 'ruby_dig'

include OpenCV

@config = YAML.load_file 'config.yml'

color_window_on = @config['color_window_on']

source_window = GUI::Window.new 'source'
capture = CvCapture::open

def get_attr(color, name, kind)
  color_attr = @config.dig 'colors', color, name, kind
  default_attr = @config.dig('defaults', name, kind)
  color_attr || default_attr
end

colors = {}
@config['colors'].each do |color, attrs|
  color_attrs = {}
  color_attrs[:low] = CvScalar.new get_attr(color, 'hue', 'low'), get_attr(color, 'saturation', 'low'), get_attr(color, 'value', 'low')
  color_attrs[:high] = CvScalar.new get_attr(color, 'hue', 'high'), get_attr(color, 'saturation', 'high'), get_attr(color, 'value', 'high')

  if color_window_on
    color_window = GUI::Window.new color

    color_window.set_trackbar("h low", 255, color_attrs[:low][0])  { |v| color_attrs[:low][0] = v }
    color_window.set_trackbar("h high", 255, color_attrs[:high][0]) { |v| color_attrs[:high][0] = v }

    color_window.set_trackbar("s low", 255, color_attrs[:low][1]) { |v| color_attrs[:low][1] = v }
    color_window.set_trackbar("s high", 255, color_attrs[:high][1]) { |v| color_attrs[:high][1] = v }

    color_window.set_trackbar("v low", 255, color_attrs[:low][2]) { |v| color_attrs[:low][2] = v }
    color_window.set_trackbar("v high", 255, color_attrs[:high][2]) { |v| color_attrs[:high][2] = v }

    color_attrs[:window] = color_window
  end

  colors[color] = color_attrs
end

loop do
  image = capture.query
  result = image.clone

  hsv = image.BGR2HSV

  colors.each do |color, color_attrs|
    color_map = hsv.in_range(color_attrs[:low], color_attrs[:high]).dilate(nil, 2)
    color_attrs[:window].show color_map if color_window_on


    unless color_window_on
      hough = color_map.hough_circles CV_HOUGH_GRADIENT, 2, 5, 200, 40
      if hough.size > 0
        circle = hough.first
        cv_color = CvColor::const_get color.capitalize
        result.circle! circle.center, circle.radius, thickness: 3, color: cv_color
      end
    end
  end

  source_window.show result
  GUI::wait_key(1)
end
