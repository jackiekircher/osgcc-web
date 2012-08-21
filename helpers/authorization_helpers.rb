module AuthorizationHelpers

  def logged_in?
    !!current_user
  end

  def current_user
    if session[:user_uid]
      @current_user ||= User.first(:uid => session[:user_uid])
    end
  end
end

class OSGCCWeb
  helpers AuthorizationHelpers
end
