class OSGCCWeb

  get '/competitions' do
    @competitions = Competition.all
    haml :'competitions/index', :layout => :default_layout
  end

  post "/competitions", :authorize => :admin do
    Time.zone = "UTC"

    name        = params[:comp_name]
    description = params[:description]
    timezone    = ActiveSupport::TimeZone.new(params[:timezone])
    start_time = Time.zone.parse("#{params[:start_date]} #{params[:start_time]}")
    end_time   = Time.zone.parse("#{params[:end_date]} #{params[:end_time]}")

    begin
      c = Competition.new(:name        => name,
                          :description => description,
                          :start_time  => start_time - timezone.now.utc_offset.seconds,
                          :end_time    => end_time - timezone.now.utc_offset.seconds,
                          :time_zone   => timezone.name)
      c.save!

      redirect "/competitions/#{c.id}"

    rescue MongoMapper::DocumentNotValid => error
      @competition = c
      @errors      = c.errors
      @zones       = ActiveSupport::TimeZone.zones_map
      haml :'competitions/new',
           :layout => :default_layout
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
    @zones       = ActiveSupport::TimeZone.zones_map
    haml :'competitions/edit', :layout => :default_layout
  end

  post '/competitions/:id', :authorize => :admin do
    Time.zone    = "UTC"
    @competition = Competition.find(params[:id])

    name        = params[:comp_name]
    description = params[:description]
    timezone    = ActiveSupport::TimeZone.new(params[:timezone])
    start_time = Time.zone.parse("#{params[:start_date]} #{params[:start_time]}")
    end_time   = Time.zone.parse("#{params[:end_date]} #{params[:end_time]}")

    @competition.update_attributes(:name        => name,
                                   :description => description,
                                   :start_time  => start_time - timezone.now.utc_offset.seconds,
                                   :end_time    => end_time - timezone.now.utc_offset.seconds,
                                   :time_zone   => timezone.name)

    redirect "/competitions/#{@competition.id}"
  end

  post '/competitions/:id/destroy', :authorize => :admin do
    @competition = Competition.find(params[:id])
    @competition.destroy

    redirect "/competitions"
  end
end
