# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9a32d74aad8124005db44b1b832882bb'
  
  private
  
  def authorize
    unless User.find_by_id(session[:user_id])
      flash[:notice]="Please login"
      redirect_to new_session_path and return
    end       
  end
  
  def logged_in
    if current_user
      return true
    else
      return false
    end  
  end
  
  def current_user
    @current_user = User.find_by_id(session[:user_id]) if session[:user_id]
  end
  
end
