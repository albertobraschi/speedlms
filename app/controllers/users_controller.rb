class UsersController < ApplicationController
	include AuthenticatedSystem
	before_filter :authorize,:only => :index
	before_filter :current_user, :only => :index
  
  def new
  
  end

  def create
    cookies.delete :auth_token # Delete cookie "auth_token" if remember_me is checked.
    reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      @current_user = @user
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
