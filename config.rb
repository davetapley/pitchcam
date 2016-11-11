require 'yaml'
require 'ruby_dig'
require_relative 'car'

WorldTransform = Struct.new :origin, :scale, :rotation

class Config

  attr_reader :world_transform, :colors, :color_window_on

  def initialize
    @config = YAML.load_file 'config.yml'

    @color_window_on = @config['color_window_on']

    origin = CvPoint.new 212, 57
    scale = 153
    rotation = 0
    @world_transform = WorldTransform.new origin, scale, rotation

    load_colors
  end


  def load_colors
    @colors = {}
    @config['colors'].each do |color, attrs|
      color_attrs = {}
      color_attrs[:low] = CvScalar.new get_attr(color, 'hue', 'low'), get_attr(color, 'saturation', 'low'), get_attr(color, 'value', 'low')
      color_attrs[:high] = CvScalar.new get_attr(color, 'hue', 'high'), get_attr(color, 'saturation', 'high'), get_attr(color, 'value', 'high')

      color_attrs[:car] = Car.new color

      @colors[color] = color_attrs
    end
  end

  private

  def get_attr(color, name, kind)
    color_attr = @config.dig 'colors', color, name, kind
    default_attr = @config.dig('defaults', name, kind)
    color_attr || default_attr
  end
end
