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

  def forgot
      if request.post?
       user = User.find_by_email(params[:user][:email])
         if user
         user.pcode = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
         user.save
         url = reset_path(:pcode => user.pcode, :only_path => false)
         email = ConfirmMailer.create_sent(user, url)
         email.set_content_type("text/html")
         ConfirmMailer.deliver(email)
        flash[:notice] = "Notification sent to #{user.email}"
       else
         flash[:notice] = "#{params[:user][:email]} does not exist in system"
       end
       redirect_back_or_default('/')
     end
  end
  
  def reset
     @user = User.find_by_pcode(params[:pcode]) unless params[:pcode].nil?
     if request.post?
       if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
         self.current_user = @user
         current_user.pcode = nil
         current_user.save
         flash[:notice] = "Password reset successfully for #{@user.email}"
         redirect_back_or_default('/')
       else 
         render :action => :reset
       end
     end
  end
   
end
