require_relative '../spec_helper'

describe Team do

  describe "#member?" do

    let(:user) { User.create(:username => "Norman", :uid => 1234) }

    it "returns true if the given user is a member of the team" do
      t = Team.new(:users => [user])
      t.member?(user).should be_true
    end

    it "returns false if the given user is not a member of the team" do
      t = Team.new
      t.member?(user).should be_false
    end
  end

  describe "#full?" do

    it "returns true if the team has <team_limit> members" do
      users = (1..Team::TEAM_LIMIT).map{ |i| User.create(:uid => i) }
      t = Team.new(:users => users)
      t.full?.should be_true
    end

    it "returns false if the team has less than 3 members" do
      users = (1..Team::TEAM_LIMIT-1).map{ |i| User.create(:uid => i) }
      t = Team.new(:users => users)
      t.full?.should be_false
    end

    it "cannot have more than three members" do
      users = (1..Team::TEAM_LIMIT+1).map{ |i| User.create(:uid => i) }
      t = Team.new(:users => users, :name => "foo", :competition_id => 1)
      t.valid?.should be_false
    end
  end

end
