class UsersController < ApplicationController
	include AuthenticatedSystem
	before_filter :authorize,:only => :index
	before_filter :current_user, :only => :index
  
  def new
    @user = User.new()
    @user.role = params[:role] if params[:role]
  end

  def create
    cookies.delete :auth_token # Delete cookie "auth_token" if remember_me is checked.
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    reset_session
    @user = User.new(params[:user])
    @user.save
    @current_user = @user
      session[:user_id] = @current_user.id 
    if @user.errors.empty?
      
      flash[:notice] = "Thanks for signing up!"
      render :action => "#{@current_user.role.downcase}_index" if @current_user.role
    else
      render :action => 'new'
    end
  end
  
  def index
    render :action => "#{@current_user.role.downcase}_index" if @current_user.role
  end

end
