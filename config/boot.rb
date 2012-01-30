
module App
  extend self

  def env
    ENV['RACK_ENV'] || 'development'
  end

  def root(path='')
    File.expand_path(File.dirname(__FILE__) + '/../' + path)
  end

  def settings
    @settings ||= YAML.load_file(root('/config/config.yml'))[env]
  end

  def production?
    env == "production"
  end
end

require_relative 'models'
require_relative '../lib/core_ext/string'
require_relative '../lib/date_generator'
