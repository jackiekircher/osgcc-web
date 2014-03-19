require_relative '../spec_helper'

describe "TeamController" do

  let(:competition) do
    Competition.create(:name       => "OSGCC 2",
                       :start_time => Time.now,
                       :end_time   => Time.now + 1.day,
                       :time_zone  => "UTC")
  end

  let(:team) do
    Team.create(:name        => "the fighting foobars",
                :competition => competition)
  end

  let(:user) do
    User.create(:username => "rachel", :uid => rand(100))
  end

  describe "new" do

    it "requires a user to be logged in" do
      get "/competitions/#{competition.id}/teams/new"

      last_response.should_not be_ok
    end

    it "loads successfully" do
      get "/competitions/#{competition.id}/teams/new", {},
          {'rack.session' => { :user_uid => user.uid }}

      last_response.should be_ok
    end

  end

  describe "create" do

    it "redirects to the competition page" do
      post "/competitions/#{competition.id}/teams",
           {:team_name => "the cold pillows"},
           {'rack.session' => { :user_uid => user.uid }}

      last_response.should be_redirect
      last_response.location.should match("/competitions/#{competition.id}$")
    end

    it "assigns the current user to the team" do
      post "/competitions/#{competition.id}/teams",
           {:team_name => "the cold pillows"},
           {'rack.session' => { :user_uid => user.uid }}

      Team.find_by(:name => "the cold pillows").members.should include user
    end
  end

  describe "edit" do

    it "fails to load if the user is not a team member" do
      get "/competitions/#{competition.id}/teams/#{team.id}", {},
          {'rack.session' => { :user_uid => user.uid }}

      last_response.should_not be_ok
    end

    it "loads successfully if the user is a team member" do
      team.add_member(user)
      team.save
      get "/competitions/#{competition.id}/teams/#{team.id}", {},
          {'rack.session' => { :user_uid => user.uid }}

      last_response.should be_ok
    end
  end

  describe "update" do

    it "fails to load if the user is not a team member" do
      post "/competitions/#{competition.id}/teams/#{team.id}",
          {:team_name => team.name},
          {'rack.session' => { :user_uid => user.uid }}

      last_response.should_not be_ok
    end

    it "redirects to the competition page" do
      team.add_member(user)
      team.save
      post "/competitions/#{competition.id}/teams/#{team.id}",
          {:team_name => team.name},
          {'rack.session' => { :user_uid => user.uid }}

      last_response.should be_redirect
      last_response.location.should match("/competitions/#{competition.id}$")
    end

    it "updates the team" do
      team.add_member(user)
      team.save
      new_name = "new team #{rand(100)}"
      post "/competitions/#{competition.id}/teams/#{team.id}",
          {:team_name => new_name},
          {'rack.session' => { :user_uid => user.uid }}

      team.reload.name.should eq new_name
    end
  end

  describe "add member" do

    let(:new_user) do
      User.create(:username => "tara", :uid => rand(100))
    end

    it "redirects to the competition page" do
      post "/team/#{team.id}/add_member/#{new_user.id}"

      last_response.should be_redirect
      last_response.location.should match("/competitions/#{competition.id}$")
    end

    it "adds the given member to the team" do
      post "/team/#{team.id}/add_member/#{new_user.id}"

      team.reload.members.should include new_user
    end
  end

  describe "remove member" do

    it "redirects to the competition page" do
      post "/team/#{team.id}/remove_member/#{user.id}"

      last_response.should be_redirect
      last_response.location.should match("/competitions/#{competition.id}$")
    end

    it "removes the given member from the team" do
      team.add_member(user)
      team.save
      post "/team/#{team.id}/remove_member/#{user.id}"

      team.reload.members.should_not include user
    end
  end

end
