class OSGCCWeb
  get '/login' do
    redirect '/auth/github'
  end

  get '/auth/github/callback' do
    auth = request.env["omniauth.auth"]

    user   = User.find_by(:uid => auth['uid'])
    user ||= User.create(:uid        => auth['uid'],
                         :username   => auth['info']['nickname'],
                         :image_url  => auth['info']['image'],
                         :created_at => Time.now)

    session[:user_uid]   = user.uid
    session[:user_token] = auth['credentials']['token']
    redirect '/'
  end

  get '/logout' do
    session.clear
    redirect '/'
  end
end
