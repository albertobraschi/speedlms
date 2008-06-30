class UsersController < ApplicationController
	include AuthenticatedSystem
	before_filter :authorize,:only => :index
	before_filter :current_user, :only => :index
  
  def new
    @user = User.new()
    @user.role = params[:role] if params[:role] 
    
  end
  
  #need modification,when use in production mode.....(needs inclusion of a transaction complete method,when return from paypal)
  def create
    cookies.delete :auth_token 
    @user = User.new(params[:user])
    if params[:role] == User::ROLE[:owner]
    	@user.plan = params[:user][:plan] if params[:user][:plan]
    	@price = SignupPlan.find_by_id(@user.plan).price
    	if @price == 0.0
	    	@user.save
	    	flash[:notice] = "Thanks for sign up!"
	    	@current_user = @user
      	session[:user_id] = @current_user.id      
    	else
    	#############needs save after successful tranaction.
    		@user.save
	    	flash[:notice] = "You need to first pay for the selected plan..."
	    	@current_user = @user
      	session[:user_id] = @current_user.id      
    	end
    else
    	@user.save
	    flash[:notice] = "Thanks for sign up!"
	    @current_user = @user
      session[:user_id] = @current_user.id
    end
       
    if @user.errors.empty?            
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
           redirect_back_or_default('/')
         else
          flash[:notice] = "Please enter a valid email"
          render :action => 'forgot'
        end 
     end
  end
  
  def reset
    @user = User.find_by_pcode(params[:pcode]) unless params[:pcode].nil?
     if request.post?
       if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
         self.current_user = @user
         @user.delete_pcode
         flash[:notice] = "Password reset successfully for #{@user.email}"
         redirect_back_or_default('/')
       else 
         flash[:notice] = "Please enter a password"
         render :action => :reset
       end
     end
  end
   
end
