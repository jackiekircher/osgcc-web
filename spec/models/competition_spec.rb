require_relative '../spec_helper'

describe Competition do

  let(:future_comp) do
    Competition.create(:name       => "future",
                       :start_time => Time.now + 1.day,
                       :end_time   => Time.now + 1.day + 1.hour,
                       :time_zone  => "UTC")
  end

  let(:current_comp) do
    Competition.create(:name       => "in progress",
                       :start_time => Time.now - 1.day,
                       :end_time   => Time.now + 1.day,
                       :time_zone  => "UTC")
  end

  let(:past_comp) do
    Competition.create(:name       => "past",
                       :start_time => Time.now - 1.day - 1.hour,
                       :end_time   => Time.now - 24.hours,
                       :time_zone  => "UTC")
  end

  describe "validates" do

    it "that the end time is greater than the start time" do

      c = Competition.new(:name => "invalid",
                          :start_time => Time.now,
                          :end_time => Time.now,
                          :time_zone => "UTC")
      c.valid?.should be_false

    end
  end

  describe ".upcoming" do

    it "returns all competitions that haven't started yet" do
      c = future_comp
      Competition.upcoming.should include c
    end

    it "does not return competitions that have started" do
      c = current_comp
      Competition.upcoming.should_not include c
    end

    it "does not return any competitions that have ended" do
      c = past_comp
      Competition.upcoming.should_not include c
    end
  end

  describe ".in_progress" do

    it "does not return any competitions that haven't started yet" do
      c = future_comp
      Competition.in_progress.should_not include c
    end

    it "returns all competitions that have started" do
      c = current_comp
      Competition.in_progress.should include c
    end

    it "does not return any competitions that have ended" do
      c = past_comp
      Competition.in_progress.should_not include c
    end
  end

  describe ".passed" do

    it "does not return any competitions that haven't started yet" do
      c = future_comp
      Competition.passed.should_not include c
    end

    it "does not return any competitions that have started" do
      c = current_comp
      Competition.passed.should_not include c
    end

    it "returns all competitions that have ended" do
      c = past_comp
      Competition.passed.should include c
    end
  end

  describe ".upcoming_or_in_progress" do

    it "returns all upcoming competitions" do
      c = future_comp
      Competition.upcoming_or_in_progress.should include c
    end

    it "returns all in-progress competitions" do
      c = current_comp
      Competition.upcoming_or_in_progress.should include c
    end

    it "does not return any competitions that have ended" do
      c = past_comp
      Competition.upcoming_or_in_progress.should_not include c
    end
  end

  describe "#passed?" do

    it "returns true if the contest end_date is in the past" do
      c = Competition.new(:end_time => Time.now - 1.day)
      c.passed?.should be_true
    end

    it "returns false if the contest end_date is in the future" do
      c = Competition.new(:end_time => Time.now + 1.day)
      c.passed?.should be_false
    end
  end

  describe "#upcoming?" do

    it "returns true if the contest start_date is in the future" do
      c = Competition.new(:start_time => Time.now + 1.day)
      c.upcoming?.should be_true
    end

    it "returns false if the contest start_date is in the past" do
      c = Competition.new(:start_time => Time.now - 1.day)
      c.upcoming?.should be_false
    end
  end

  describe "#in_progress?" do
    it "returns true if the current time is between the start and end dates" do
      c = Competition.new(:start_time => Time.now - 1.day,
                          :end_time   => Time.now + 1.day)
      c.in_progress?.should be_true
    end

    it "returns false if the contest is upcoming" do
      c = Competition.new(:start_time => Time.now + 1.day,
                          :end_time   => Time.now + 1.day + 1.hour)
      c.in_progress?.should be_false
    end

    it "returns false if the contest has passed" do
      c = Competition.new(:start_time => Time.now - 1.day - 1.hour,
                          :end_time   => Time.now - 1.day)
      c.in_progress?.should be_false
    end
  end
end
