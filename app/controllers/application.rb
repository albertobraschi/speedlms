class ApplicationController < ActionController::Base
  
  ActiveScaffold.set_defaults do |config|
    config.ignore_columns.add [:created_at, :updated_at, :status]
  end
 
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
  
  def authorized_as_admin
  	unless  @current_user and @current_user.is_admin?
  		flash[:notice]="Please login as Administrator"
      redirect_to new_session_path and return
  	end
  end

  # It automatically logins user if he has checked remember_me option.


  def login_from_cookie
    return unless cookies[:auth_token] && session[:user_id].nil?
    user = User.find_by_remember_token(cookies[:auth_token]) 
    if user && !user.remember_token_expires.nil? && Time.now < user.remember_token_expires 
      session[:user_id] = user.id
      respond_to do |format|
        format.html {redirect_to users_path}
        format.js
      end
    end
  end
  
  #Finds current user 
  def current_user
    @current_user = User.find_by_id(session[:user_id])  if session[:user_id]    
  end
	 
end
