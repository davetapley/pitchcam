#!/usr/bin/env ruby

require 'rubygems'

require "opencv"
include OpenCV

require_relative 'config'
require_relative 'track'
require_relative 'dev_ui'
require_relative 'image_processor'

config = Config.new

include DevUI

add_color_windows config.colors if config.color_window_on

# 864 x 480
capture = CvCapture::open 0


# add_world_transform_trackbars source_window

track = Track.new config.world_transform
source_window = GUI::Window.new 'source'

image_processor = ImageProcessor.new config.world_transform, config.colors, track, source_window

loop do
  image = capture.query

  image_processor.handle_image image

  GUI::wait_key(1)
end
