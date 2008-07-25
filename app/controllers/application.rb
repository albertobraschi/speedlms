class ApplicationController < ActionController::Base
  
  # Include all helpers, all the time
  helper :all
   
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9a32d74aad8124005db44b1b832882bb'
  
  helper_method :pages, :current_user
  
  include Spelling 
  def spellcheck 
    @headers['Content-Type'] = 'text/xml' 
    @headers['charset'] = 'utf-8' 
    suggestions = check_spelling(params[:check], params[:cmd], params[:lang]) 
    xml = "#{suggestions}"
    render :text => xml
    return
  end
  
  #Finds all viewable pages.
  def pages
  	@pages = Page.find_viewable_pages
  end
  
  #Finds Current User 
  def current_user
    @current_user = User.find_by_id(session[:user_id])  if session[:user_id]    
  end
    
  private
  #Checks whether an User is authorized or not?
  def authorize
    unless User.find_by_id(session[:user_id])
      flash[:notice]="Please login"
      redirect_to new_session_path and return
    end       
  end
  
  #Checks whether an User is an Admin or not!
  def authorized_as_admin
  	unless  @current_user and @current_user.is_admin?
  		flash[:notice]="Please login as Administrator"
      redirect_to new_session_path and return
  	end
  end

  # It automatically makes an User logged in,if he has checked remember_me option while login.
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

 # Not used currently	
 # Finds the subdomain if present in the url for a given request
  def current_subdomain
    @current_subdomain = self.request.subdomains[0]
  end
  
end
