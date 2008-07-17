class OwnersController < ApplicationController
	before_filter :current_user, :except=>[:new, :create]
	before_filter :authorize, :only=>[:index]
	def new
		if current_user
    	flash[:notice] = "Firstly logout and then create new owner"
			if current_user.is_admin?      		
     		redirect_to admin_users_path and return 
     	else     		
     		redirect_to users_path and return
     	end
    end
    	@user = User.new()
	    @owner = Owner.new() 
  	  render :layout => 'public'
	end
	
	def create
		cookies.delete :auth_token
		@user = User.new(params[:user]) 
    @owner = Owner.new(params[:owner])
    @user.resource = @owner
    @price = SignupPlan.find_by_id(@owner.signup_plan_id).price if @owner.signup_plan_id
    if @user.valid? 
    	#FREE is a constant and equal to 0.0
    	if @price == FREE
    		successful_signup
    	else
   			redirect_to :action => "payment",:id => @owner.signup_plan_id
   		end
   	else
   		render :action => 'new',:layout => 'public'
   	end
	end
	
	def index
		
	end
	
	def edit
		
	end
	
	def update
		
	end
	
	def destroy
		
	end
	
	#checks availability of username for owner  
  def check_username_availability
  	@username = params[:owner][:login]
  	@users = User.find(:all)
  	if !@username.blank?
  		@users.each do |user|
  			if @username == user.login 				
  				@message = "Username not available"
  				break
  			else
  				@message = "Username available."
  			end
  		end
  	else
  		@message = "Username should not be blank."
  	end
  	render :update do |page|
  		page.replace_html 'username_availability_message',@message
  	end
  end
  
  #checks availability of speedlms subdomain for owner
  def check_subdomain_availability
  	@subdomain = params[:owner][:speedlms_subdomain]
  	@users = User.find(:all)
  	if !@subdomain.blank?
  		@users.each do |user|
  			if @subdomain == user.speedlms_subdomain
  				@message = "Subdomain not available"
  				break
  			else
  				@message = "Subdomain available."
  			end
  		end
  	else
  		@message = "Subdomain should not be blank."
  	end
  	render :update do |page|
  		page.replace_html "subdomain_availability_message",@message
  	end
  end
  

 private
  #saves user and makes him/her current user.
  def successful_signup 
    @user.save
	  #email = OwnerWelcomeMail.create_sent(@owner)
	  #email.set_content_type("text/html")
	  #OwnerWelcomeMail.deliver(email)
	  flash[:notice] = "Thanks for sign up!"
	  @current_user = @user
    session[:user_id] = @current_user.id
    @owner = Owner.find_by_id(@current_user.resource_id)
    url = @owner.speedlms_url + users_path(:sess => session[:user_id])
    redirect_to url
  end 
   
end
