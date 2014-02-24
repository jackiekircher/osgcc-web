class OSGCCWeb
  configure :test do
    db = URI.parse('postgres://localhost/osgcc-web-test')

    ActiveRecord::Base.establish_connection(
      :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
    )
  end

  configure :development do
    db = URI.parse('postgres://localhost/osgcc-web-development')

    ActiveRecord::Base.establish_connection(
      :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
    )
  end
end
