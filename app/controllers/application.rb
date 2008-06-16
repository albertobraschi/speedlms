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
  
  def login_from_cookie
    return unless cookies[:auth_token] && session[:user].nil?
    user = User.find_by_remember_token(cookies[:auth_token]) 
    if user && !user.remember_token_expires.nil? && Time.now < user.remember_token_expires 
      session[:user] = user
      respond_to do |format|
        format.html {redirect_to users_path}
        format.js
      end
    end
  end
  
  def current_user
    @current_user = User.find_by_id(session[:user_id])  if session[:user_id]    
  end
  
end
