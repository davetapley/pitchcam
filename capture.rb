require 'sinatra'

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

track = Track.new config.world_transform
image_processor = ImageProcessor.new track, config.colors
race = Race.new track, config.color_names

helpers do
  def dev_image(race, image, dirty_colors, colors)
    track = race.track
    result = image.clone

    track.render_outline_to result

    race.colors_entrants.each do |color, entrant|
      next unless entrant.on_track?
      cv_color = CvColor::const_get color.capitalize
      thickness = entrant.is_turn ? 3 : 1
      world_position = track.world_from_position entrant.track_position
      #puts "#{color} at #{entrant.track_position}"
      result.circle! world_position, track.car_radius_world, thickness: thickness, color: cv_color
      #puts "#{color}\tcalc\t#{world_position}"

      track.render_progress_to result, cv_color, entrant.track_position
    end

    result
  end
end

post '/image' do
  file = params['webcam'][:tempfile].path
  image = IplImage.load file
  dirty_colors = image_processor.handle_image image
  race.update dirty_colors if dirty_colors.any?
  $latest_dev_image = dev_image race, image, dirty_colors, config.colors
  logger.info $latest_dev_image
  true
end

get '/dev_image.png' do
  unless $latest_dev_image.nil?
    tmp_file =  '/tmp/image.png'
    $latest_dev_image.save_image tmp_file
    send_file tmp_file

  else
    'Please wait'
  end
end

