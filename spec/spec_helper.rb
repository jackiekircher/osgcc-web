ENV['RACK_ENV'] = 'test'

require 'capybara/rspec'
require 'database_cleaner'
require 'omniauth'
require 'rack/test'

require_relative '../osgcc_web'
require_relative './acceptance_helpers.rb'

Capybara.app = OSGCCWeb

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include AcceptanceHelpers, :type => :feature

  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(
    :github,
    {
      :uid => 1111,
      :credentials => {
        :token => 'itsasecrettoeveryone'
      }
    }
  )

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
