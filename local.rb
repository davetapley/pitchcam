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
add_world_transform_trackbars source_window, config.world_transform

track = Track.new config.world_transform
image_processor = ImageProcessor.new track, config.colors
race = Race.new track, config.color_names

# 864 x 480
capture = CvCapture::open 0

loop do
  image = capture.query

  dirty_colors = image_processor.handle_image image
  race.update dirty_colors if dirty_colors.any?
  render_dev_overlay race, source_window, image, dirty_colors, config.colors, config.color_window_on

  GUI::wait_key 1
end
