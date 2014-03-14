require_relative "../spec_helper"

describe "HomeController" do

  describe "/" do

    it "loads successfully" do
      get "/"
      last_response.should be_ok
    end
  end

  describe "/about" do

    it "loads successfully" do
      get "/about"
      last_response.should be_ok
    end
  end

  describe "/contact" do

    it "loads successfully" do
      get "/contact"
      last_response.should be_ok
    end
  end
end
