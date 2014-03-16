require_relative '../spec_helper'

class Helpers
  include CompetitionHelpers
end

describe CompetitionHelpers do

  let(:helper) { Helpers.new }

  describe "selected_timezone?" do

    let(:zone) do
      "UTC"
    end

    let(:competition) do
      Competition.new(:time_zone => zone)
    end

    it "returns true if the competition's timezone matches
        the given zone" do
      timezone = ActiveSupport::TimeZone.new(zone)
      helper.matches_timezone?(competition, timezone).should be_true
    end

    it "returns false if the competition's timezone does not
        match the given zone" do
      timezone = ActiveSupport::TimeZone.new("Hawaii")
      helper.matches_timezone?(competition, timezone).should be_false
    end
  end
end
