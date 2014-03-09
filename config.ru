require './osgcc_web'
require 'sass/plugin/rack'

use Sass::Plugin::Rack
run OSGCCWeb
