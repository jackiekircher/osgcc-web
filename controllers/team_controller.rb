class OSGCCWeb

  get '/competitions/:id/teams/new', :authorize => :user do
    @competition = Competition.find(params[:id])
    @team = @competition.teams.build
    haml :'teams/new', :layout => :default_layout
  end

  post '/competitions/:id/teams', :authorize => :user do
    @competition = Competition.find(params[:id])
    @team = @competition.teams.build(:name           => params[:team_name],
                                     :repository_url => params[:repo_url],
                                     :members        => [current_user])
    begin
      @team.save!
      redirect "/competitions/#{@competition.id}"
    rescue ActiveRecord::RecordInvalid => error
      @errors = @team.errors
      haml :'teams/new', :layout => :default_layout
    end
  end

  post '/team/:team_id/add_member/:user_id' do
    @team = Team.includes(:competition).find(params[:team_id])
    @user = User.find(params[:user_id])
    @team.add_member(@user)
    @team.save!

    redirect "/competitions/#{@team.competition.id}"
  end

  post '/team/:team_id/remove_member/:user_id' do
    @team = Team.includes(:competition).find(params[:team_id])
    @user = User.find(params[:user_id])
    @team.remove_member(@user)
    @team.save!

    redirect "/competitions/#{@team.competition.id}"
  end
end
