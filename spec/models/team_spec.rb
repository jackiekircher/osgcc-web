require_relative '../spec_helper'

describe Team do

  describe "#member?" do

    let(:user) { User.create(:username => "Norman", :uid => 1234) }

    it "returns true if the given user is a member of the team" do
      t = Team.new(:members => [user])
      t.member?(user).should be_true
    end

    it "returns false if the given user is not a member of the team" do
      t = Team.new
      t.member?(user).should be_false
    end
  end

  describe "#full?" do

    it "returns true if the team has <team_limit> members" do
      members = (1..Team::TEAM_LIMIT).map{ |i| User.create(:uid => i) }
      t = Team.new(:members => members)
      t.full?.should be_true
    end

    it "returns false if the team has less than 3 members" do
      members = (1..Team::TEAM_LIMIT-1).map{ |i| User.create(:uid => i) }
      t = Team.new(:members => members)
      t.full?.should be_false
    end

    it "cannot have more than three members" do
      members = (1..Team::TEAM_LIMIT+1).map{ |i| User.create(:uid => i) }
      t = Team.new(:members => members, :name => "foo", :competition_id => 1)
      t.valid?.should be_false
    end
  end

  describe "#add_member" do

    it "returns false if the team is full" do
      team = Team.new
      user = User.new
      team.stub(:full? => true)
      team.add_member(user).should be_false
    end

    it "returns true if a member is added" do
      team = Team.new
      user = User.new
      team.add_member(user).should be_true
    end

    it "adds the user to the list of members" do
      team = Team.new
      user = User.new
      team.add_member(user)
      team.members.should include user
    end
  end

end
