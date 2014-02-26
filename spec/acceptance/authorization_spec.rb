require_relative '../spec_helper.rb'

describe 'OSGCC-Web authentications', :type => :feature do

  def app
    OSGCCWeb
  end

  describe "logging in" do

    it "creates a user from the auth uid if none exists" do
      new_name = "kingston"
      new_uid  = 5555
      OmniAuth.config.mock_auth[:github][:info][:nickname] = new_name
      OmniAuth.config.mock_auth[:github][:uid] = new_uid

      visit '/login'
      page.should have_content new_name
    end

    it "logs the user in" do
      mock_auth(regular_user.uid)
      visit '/login'
      page.should have_content regular_user.username
    end
  end

  describe "/logout" do

    before :each do
      login_as regular_user
    end

    it "logs the user out" do
      visit '/logout'
      page.should_not have_content regular_user.username
    end

    it "returns to the home page" do
      visit '/logout'
      page.current_path.should == '/'
    end
  end
end
