require 'sinatra'
require 'mongo_mapper'
require 'debugger'

class OSGCCWeb < Sinatra::Base
  set :app_file, '.'
  set :haml, :format => :html5

  enable :sessions
end

%w(config helpers controllers models).each do |dir|
  Dir[File.join(File.dirname(__FILE__), dir, '*.rb')].each {|file| require file }
end
