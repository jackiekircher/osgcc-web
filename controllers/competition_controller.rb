class OSGCCWeb

  get '/competitions' do
    @competitions = Competition.all
    haml :'competitions/index', :layout => :default_layout
  end

  post "/competitions", :authorize => :admin do

    name       = params[:comp_name]
    timezone   = ActiveSupport::TimeZone.new(params[:timezone])
    start_time = DateTime.strptime("#{params[:start_date]}T#{params[:start_time]}","%Y-%m-%dT%H:%M")
    end_time   = DateTime.strptime("#{params[:end_date]}T#{params[:end_time]}","%Y-%m-%dT%H:%M")

    begin
      c = Competition.new(:name       => name,
                          :start_time => start_time - timezone.utc_offset.seconds,
                          :end_time   => end_time - timezone.utc_offset.seconds,
                          :time_zone  => timezone.name)
      c.save!

      redirect "/competitions/#{c._id.to_s}"

    rescue MongoMapper::DocumentNotValid => error
      @competition = c
      @zones       = ActiveSupport::TimeZone.zones_map
      haml :'competitions/new',
           :layout => :default_layout,
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
    @competition = Competition.new(:start_time => Time.now,
                                   :end_time   => Time.now + 1.day,
                                   :time_zone  => "Eastern Time (US & Canada)")
    @zones = ActiveSupport::TimeZone.zones_map
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
    start_time = DateTime.strptime("#{params[:start_date]}T#{params[:start_time]}","%Y-%m-%dT%H:%M")
    end_time   = DateTime.strptime("#{params[:end_date]}T#{params[:end_time]}","%Y-%m-%dT%H:%M")
    @competition.update_attributes(:name       => name,
                                   :start_time => start_time,
                                   :end_time   => end_time)

    redirect "/competitions/#{@competition._id.to_s}"
  end
end
