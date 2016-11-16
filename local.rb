#!/usr/bin/env ruby

require 'rubygems'
require 'pry'

require "opencv"
include OpenCV

require_relative 'config'
require_relative 'track'
require_relative 'dev_ui'
require_relative 'image_processor'
require_relative 'race'

config = Config.new

include DevUI

source_window = GUI::Window.new 'source'
# add_world_transform_trackbars source_window
color_windows = add_color_windows config.colors if config.color_window_on


track = Track.new config.world_transform
image_processor = ImageProcessor.new track, source_window, config.colors_attrs, color_windows
race = Race.new track, config.colors

# 864 x 480
capture = CvCapture::open 0

loop do
  image = capture.query

  dirty_colors = image_processor.handle_image image
  race.update dirty_colors if dirty_colors.any?

  GUI::wait_key(1)
end
