class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  before_filter :authorize,:only => :index
  include AuthenticatedSystem
  

  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      flash[:notice] = "Thanks for signing up!"
      respond_to do |format|
        format.html {redirect_to users_path}
        format.js
      end
    else
      render :action => 'new'
    end
  end
  
  def index
    
  end

end
