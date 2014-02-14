class OSGCCWeb

  get '/competitions' do
    @competitions = Competition.all
    haml :'competitions/index', :layout => :default_layout
  end

  post "/competitions", :authorize => :admin do

    name       = params[:comp_name]
    timezone   = TimezonePrinter.new(TZInfo::Timezone.get(params[:timezone]))
    start_date = DateTime.strptime("#{params[:start_date]}T#{params[:start_time]}#{timezone.abbr}","%Y-%m-%dT%I:%M%P%Z")
    end_date   = DateTime.strptime("#{params[:end_date]}T#{params[:end_time]}#{timezone.abbr}","%Y-%m-%dT%I:%M%P%Z")

    begin
      c = Competition.create!(:name => name, :start_date => start_date, :end_date => end_date, :tz_identifier => timezone.identifier)

      redirect "/competitions/#{c._id.to_s}"

    rescue MongoMapper::DocumentNotValid => error
      @zones = TimezonePrinter.filtered_list
      haml :'competitions/new', :layout => :default_layout,
           :locals => {:params => params}
    end
  end

  get '/competitions/past' do
    @competitions = Competition.passed.all
    haml :'competitions/index', :layout => :default_layout
  end

  get '/competitions/upcoming' do
    @competitions = Competition.upcoming_or_in_progress
    haml :'competitions/index', :layout => :default_layout
  end

  get '/competitions/new', :authorize => :admin do
    @zones = TimezonePrinter.filtered_list
    haml :'competitions/new', :layout => :default_layout
  end

  get '/competitions/:id' do
    @competition = Competition.find(params[:id])
    haml :'competitions/show', :layout => :default_layout
  end

  get '/competitions/:id/edit', :authorize => :admin do
    @competition = Competition.find(params[:id])
    haml :'competitions/edit', :layout => :default_layout
  end

  post '/competitions/:id', :authorize => :admin do
    @competition = Competition.find(params[:id])

    name       = params[:comp_name]
    start_date = DateTime.strptime("#{params[:start_date]}T#{params[:start_time]}","%Y-%m-%dT%I:%M%P")
    end_date   = DateTime.strptime("#{params[:end_date]}T#{params[:end_time]}","%Y-%m-%dT%I:%M%P")
    @competition.update_attributes(:name => name, :start_date => start_date, :end_date => end_date)

    redirect "/competitions/#{@competition._id.to_s}"
  end
end
