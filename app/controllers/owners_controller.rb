class OwnersController < ApplicationController
	before_filter :current_user, :except=>[:new, :create]
	before_filter :authorize, :only=>[:index]
	before_filter :authorize_owner, :only => [:edit, :update, :destroy]
	before_filter :pages
	def new
		if current_user
    	flash[:notice] = "Firstly logout and then create new owner"
			if current_user.is_admin?      		
     		redirect_to admin_users_path and return 
     	elsif current_user.is_owner?     		
     		redirect_to owners_path and return
     	elsif current_user.is_tutor?     		
     		redirect_to tutors_path and return
     	elsif current_user.is_student?     		
     		redirect_to students_path and return
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
	
	#Edits user's information
  def edit
  	@owner = Owner.find_by_id(params[:id])
  	@user = @current_user
  end
  
  #Updates user's information
  def update
  	@user = @current_user
    @owner = Owner.find_by_id(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user]) and @owner.update_attributes(params[:owner])
        flash[:notice] = "User was sucessfully updated"
        format.html { redirect_to owners_url}
      else  
        format.html {render :action => "edit"}
      end
    end    
  end  
	
	def destroy
		
	end
  
  #checks availability of speedlms subdomain for owner
  def check_subdomain_availability
  	@subdomain = params[:owner][:speedlms_subdomain]
  	@users = User.find(:all, :conditions => ["resource_type = ? or resource_type = ?",'Owner','Tutor'])  			
  	if !@subdomain.blank?
  		if @users.blank?
  			@message = "Subdomain available."
  		else 
  			@users.each do |user|
  				if @subdomain == user.resource.speedlms_subdomain
  					@message = "Subdomain not available"
  					break
  				else
  					@message = "Subdomain available."
  				end
  			end
  		end
  	else
  			@message = "Subdomain should not be blank."
  	end
  	render :update do |page|
  	page.replace_html "subdomain_availability_message",@message
 	end
  end
  
  #Used to add and invite tutors.
  def add_tutors
	 @owner = @current_user.resource
	 @tutors = Tutor.find(:all, :conditions => ["owner_id = ? ",  @owner.id])
    if request.post?
	    @user = User.new(params[:user])
	    @user.resource_type = RESOURCE_TYPE[:tutor]
	    @tutor = Tutor.new(params[:tutor])
	    @user.resource = @tutor
	    @tutor.owner = @owner
       if @user.save
         email = LoginDetailsMailer.create_sent(@user)
		     email.set_content_type("text/html")
		     LoginDetailsMailer.deliver(email)
         flash[:notice] = "#{@user.login} is added as a tutor"
		     @user = User.new
       end 
     end         
  end  

 private
  #saves user and makes him/her current user.
  def successful_signup
    @user.save
	  email = OwnerWelcomeMail.create_sent(@user)
	  email.set_content_type("text/html")
	  OwnerWelcomeMail.deliver(email)
	  flash[:notice] = "Thanks for sign up!"
	  @current_user = @user
    session[:user_id] = @current_user.id
    @owner = Owner.find_by_id(@current_user.resource_id)
    url = @owner.speedlms_url + owners_path
    redirect_to url
  end 
  
  def authorize_owner
  owner = Owner.find_by_id(params[:id])
  	unless current_user.resource == owner
  		flash[:notice] = "You are not authorize to edit this user."
  		redirect_to root_path	
  	end
  end
  
end
