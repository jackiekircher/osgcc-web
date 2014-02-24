require './osgcc_web'

api_keys_file = 'config/api_keys.yml'
api_keys      = YAML.load_file(api_keys_file)[ENV['RACK_ENV']]
api_keys.each{ |key, value| ENV[key] = value }

env_keys_file = 'config/env_keys.yml'
env_keys      = YAML.load_file(env_keys_file)[ENV['RACK_ENV']]
env_keys.each{ |key, value| ENV[key] = value }

run OSGCCWeb
