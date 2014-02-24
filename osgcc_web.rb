require 'sinatra'
require 'sinatra/activerecord'
require 'debugger'

class OSGCCWeb < Sinatra::Base
  set :app_file, '.'
  set :haml, :format => :html5

  use Rack::Session::Cookie, :key    => 'rack.session',
                             :domain => ENV['DOMAIN'],
                             :expire_after => 172800, # 48 hours
                             :secret => ENV['SECRET_TOKEN']
end

%w(config helpers controllers models).each do |dir|
  Dir[File.join(File.dirname(__FILE__), dir, '*.rb')].each {|file| require file }
end
