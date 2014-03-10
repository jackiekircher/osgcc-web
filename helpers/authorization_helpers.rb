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
    logged_in? && current_user.admin?
  end

  def organizer?(competition)
    logged_in? && (current_user == competition.organizer)
  end
end

class OSGCCWeb
  helpers AuthorizationHelpers
end
