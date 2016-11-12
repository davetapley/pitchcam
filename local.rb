#!/usr/bin/env ruby

require 'rubygems'
require 'pry'

puts (-1)
require "opencv"
puts 0
include OpenCV

require_relative 'config'
require_relative 'track'
require_relative 'dev_ui'
require_relative 'image_processor'
require_relative 'race'

config = Config.new

puts 1

include DevUI

add_color_windows config.colors if config.color_window_on

# 864 x 480
capture = CvCapture::open 0


puts 2

# add_world_transform_trackbars source_window

track = Track.new config.world_transform
source_window = GUI::Window.new 'source'

puts 3

image_processor = ImageProcessor.new config.world_transform, config.colors, track, source_window

race = Race.new track, config.colors.map { |_, attrs| attrs[:car] }

puts 4

loop do
  image = capture.query

  dirty_cars = image_processor.handle_image image
  race.update dirty_cars if dirty_cars.any?

  GUI::wait_key(1)
end
