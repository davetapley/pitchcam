require 'sinatra'
require 'sinatra/reloader'

require 'rubygems'

require "opencv"
include OpenCV

require_relative 'config'
require_relative 'track'
require_relative 'image_processor'


config = Config.new

add_color_windows config.colors if config.color_window_on

# add_world_transform_trackbars source_window

track = Track.new config.world_transform
source_window = GUI::Window.new 'source'

image_processor = ImageProcessor.new config.world_transform, config.colors, track, source_window

get '/' do
  <<-HTML
    <script src="webcam.min.js"></script>

    <div id="my_camera" style="width:320px; height:240px;"></div>
    <div id="my_result"></div>

    <script language="JavaScript">
        Webcam.attach( '#my_camera' );

        function take_snapshot() {
            Webcam.snap( function(data_uri) {
                document.getElementById('my_result').innerHTML = '<img src="'+data_uri+'"/>';
                Webcam.upload( data_uri, 'image', function() {
                  take_snapshot();
                })

            } );
        }
    </script>

    <a href="javascript:void(take_snapshot())">Take Snapshot</a>
  HTML
end

post '/image' do
  file = params['webcam'][:tempfile].path
  puts file
  image = IplImage.load file
  image_processor.handle_image image
end
