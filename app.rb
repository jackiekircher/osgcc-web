require 'sinatra'
require 'mongo_mapper'
require 'omniauth'
require 'omniauth-github'
require_relative 'models/user'

set :haml, :format => :html5

# omniauth

use Rack::Session::Cookie
use OmniAuth::Builder do
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
end

configure do
  MongoMapper.database = 'osgcc'
end

helpers do
  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.first(:uid => session[:user_uid]) if session[:user_uid]
  end
end

get '/' do
  haml :index, :layout => :home_layout
end

get '/about' do
  haml :about, :layout => :home_layout
end

get '/contact' do
  haml :contact, :layout => :home_layout
end

get '/logout' do
  session[:user_uid] = nil
  redirect '/'
end

get '/auth/github/callback' do
  auth = request.env["omniauth.auth"]

  user   = User.first( :uid => auth['uid'] )
  user ||= User.create(:uid        => auth['uid'],
                       :username   => auth['info']['nickname'],
                       :created_at => Time.now)

  session[:user_uid] = user.uid
  redirect '/'
end
