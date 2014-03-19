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

  get '/competitions/:competition_id/teams/:team_id', :authorize => :user do
    @competition = Competition.includes(:teams).find(params[:competition_id])
    @team = @competition.teams.find(params[:team_id])

    raise Sinatra::NotFound unless @team.member?(current_user)

    haml :'teams/edit', :layout => :default_layout
  end

  post '/competitions/:competition_id/teams/:team_id', :authorize => :user do
    @competition = Competition.find(params[:competition_id])
    @team = @competition.teams.find(params[:team_id])

    raise Sinatra::NotFound unless @team.member?(current_user)

    begin
      @team.update_attributes!(:name           => params[:team_name],
                               :repository_url => params[:repo_url])
      redirect "/competitions/#{@competition.id}"
    rescue ActiveRecord::RecordInvalid => error
      @errors = @team.errors
      haml :'teams/edit', :layout => :default_layout
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
