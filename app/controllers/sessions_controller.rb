class SessionsController < ApplicationController

  #This makes various methods of Restful_Authentication available to all actions of Sessions Controller.
  include AuthenticatedSystem
	
  # This filter looks for presence of remember_me option while an user sings in.
  before_filter :login_from_cookie, :only => [:new,:create] 
	
  #This makes all viewable pages available to all actions.
  before_filter :pages
	
  # Creates new instance of Session and checks if there is already a session.
  def new
    #Firstly checks for if there is someone logged in.
    if current_user
      flash[:notice] = "You are already logged in - YAHOO"
      if @current_user.is_admin?      		
        redirect_to admin_users_path and return 
      elsif @current_user.is_owner?     		
        redirect_to owners_path and return
      elsif @current_user.is_tutor?     		
        redirect_to tutors_path and return
      elsif @current_user.is_student?     		
        redirect_to students_path and return
      end
    end
    render :layout => 'login'
  end
  	
  # Creates session for either openid or username/password login
  def create
    if using_open_id?
      open_id_authentication
    else
      password_authentication(params[:name], params[:password])       
    end
  end
	
  # Displays the MAIN index Page	
  def index
    render :layout => 'login'
  end
	
  # View Pages for Public display that has created by Admin user
  def view_pages
    current_user
    current_subdomain
    if @current_subdomain
    	redirect_to new_session_path
    else
		  if params[:id]
		    @page = Page.find_by_id(params[:id])
		  else
		    @page = Page.find_index_page
		  end
		  render :layout => 'public'
    end
  end
  	
  # Destroys session    
  def destroy
    current_user
    if @current_user.is_owner?
      url = Owner.find(@current_user.resource_id).speedlms_url
    elsif @current_user.is_admin?
      url = 'http://speedlms.dev'
    end
    @current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:message] = "You are successfully logged out."
    respond_to do |format|
      format.html {redirect_to url}
      format.js
    end
  end
                            
  protected
	
  # Checks authentication for username/password login	
  def password_authentication(name, password)
    if @current_user =User.authenticate(params[:name], params[:password])
      successful_login
    else
      failed_login "Sorry, Invaild login."
    end
  end

  # Checks authentication for openid login	
  def open_id_authentication 
    authenticate_with_open_id do |result, identity_url|
      if result.successful?
        if @current_user = User.find_or_create_by_identity_url(identity_url)
          successful_login
        else
          failed_login "Sorry, no user by that identity URL exists (#{identity_url})"
        end
      else
        failed_login result.message
      end
    end
  end
        
  private
	
  # Checks for presence of remember me redirects users according to their role
  def successful_login
    session[:user_id] = @current_user.id
    if logged_in?
      if params[:remember_me] == "yes"
        @current_user.remember_me unless @current_user.remember_token?
        cookies[:auth_token] = { :value => @current_user.remember_token , :expires => @current_user.remember_token_expires_at }
      end
      flash[:notice] = "Logged in successfully"
      if @current_user.is_admin?
        respond_to do |format|
          format.html {redirect_to admin_users_path and return}
          format.js
        end					
      elsif @current_user.is_owner?
        @owner = Owner.find_by_id(@current_user.resource_id)
        url = @owner.speedlms_url + owners_path
        redirect_to url
      elsif @current_user.is_tutor?
        @tutor = Tutor.find_by_id(@current_user.resource_id)
        url = @tutor.speedlms_url + tutors_path
        redirect_to url
      end    
    else
      render :action => 'new'
    end    
  end

  # Redirect user to login page if current attempt fails
  def failed_login(message)
    flash[:error] = message
    respond_to do |format|
      format.html {redirect_to new_session_url}
      format.js
    end
  end
	
end
