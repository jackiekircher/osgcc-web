module AuthorizationHelpers

  def logged_in?
    !!current_user
  end

  def current_user
    if session[:user_uid]
      @current_user ||= User.find_by(:uid => session[:user_uid])
    end
  end

  def authorized?
    return (logged_in? && current_user.admin?)
  end
end

class OSGCCWeb
  helpers AuthorizationHelpers
end
