class OSGCCWeb

  get '/competitions/:id/teams/new', :authorize => :user do
    @competition = Competition.find(params[:id])
    @team = @competition.teams.build
    haml :'teams/new', :layout => :default_layout
  end

  post '/competitions/:id/teams', :authorize => :user do
    @competition = Competition.find(params[:id])
    @team = @competition.teams.build(:name    => params[:team_name],
                                     :members => [current_user])
    begin
      @team.save!
      redirect "/competitions/#{@competition.id}"
    rescue ActiveRecord::RecordInvalid => error
      @errors = @team.errors
      haml :'teams/new', :layout => :default_layout
    end
  end
end
