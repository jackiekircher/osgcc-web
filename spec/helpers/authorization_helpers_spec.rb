require_relative '../spec_helper'

class Helpers
  include AuthorizationHelpers
end

describe AuthorizationHelpers do

  let(:helper) { Helpers.new }

  describe "organizer?" do

    let(:competition) { Competition.new }
    let(:user)        { User.new }

    it "returns false when there is no one logged in" do
      helper.stub(:current_user => false)

      helper.organizer?(competition).should be_false
    end

    it "returns false when the current user is not the
        organizer for the given compeition" do
      helper.stub(:current_user => user)

      helper.organizer?(competition).should be_false
    end

    it "returns true when the current user is the organizer
        for the given competition" do
      helper.stub(:current_user => user)
      competition.organizer = user

      helper.organizer?(competition).should be_true
    end
  end
end
