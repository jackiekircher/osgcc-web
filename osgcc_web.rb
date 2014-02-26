require 'sinatra'
require 'sinatra/activerecord'
require 'debugger'

class OSGCCWeb < Sinatra::Base
  set :app_file, '.'
  set :haml, :format => :html5

  api_keys_file = 'config/api_keys.yml'
  api_keys      = YAML.load_file(api_keys_file)[ENV['RACK_ENV']].to_a
  api_keys.each{ |key, value| ENV[key] = value }

  env_keys_file = 'config/env_keys.yml'
  env_keys      = YAML.load_file(env_keys_file)[ENV['RACK_ENV']].to_a
  env_keys.each{ |key, value| ENV[key] = value }

  use Rack::Session::Cookie, :key    => 'rack.session',
                             :domain => ENV['DOMAIN'],
                             :expire_after => 172800, # 48 hours
                             :secret => ENV['SECRET_TOKEN']
end

%w(config helpers controllers models).each do |dir|
  Dir[File.join(File.dirname(__FILE__), dir, '*.rb')].each {|file| require file }
end
