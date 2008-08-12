class OwnersController < ApplicationController
	#This makes current user available to all actions except new and create.
	before_filter :current_user
	
	#This prevents unauthorized users to access index page.
	before_filter :authorize, :only=>[:index]
	
	#This makes sure that a user can edit,update or destroy only his/her own account.
	before_filter :authorize_owner, :only => [:edit,:update,:destroy]
	
	def new
		#Firstly checks for if there is someone logged in.
		if @current_user
    	flash[:notice] = "Firstly logout and then create."
			if @current_user.is_admin?      		
     		redirect_to admin_users_path and return 
     	elsif @current_user.is_owner?     		
     		redirect_to ownerDesk_path and return
     	elsif @current_user.is_tutor?     		
     		redirect_to tutors_path and return
     	elsif @current_user.is_student?     		
     		redirect_to students_path and return
     	end
    end
    	@user = User.new()
	    @owner = Owner.new() 
  	  render :layout => 'login'
	end
	
	def create		
		cookies.delete :auth_token
		@user = User.new(params[:user])
		@user.resource_type = RESOURCE_TYPE[:owner] 
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
   		render :action => 'new',:layout => 'login'
   	end
	end
	
	def index
		@owner = @current_user.resource
		@tutors = @owner.tutors
		@courses = @owner.courses
	end
	
	#Edits owner's information
  def edit
  	@owner = Owner.find_by_id(params[:id])
  	@user = @current_user
  end
  
  #Updates owner's information
  def update
  	@user = @current_user
    @owner = Owner.find_by_id(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user]) and @owner.update_attributes(params[:owner])
        flash[:notice] = "User was sucessfully updated"
        format.html { redirect_to ownerDesk_url}
      else  
        format.html {render :action => "edit"}
      end
    end    
  end  
  
  #Checks availability of speedlms subdomain for owner
  def check_subdomain_availability
  	#Checks if the user creating is an owner.
  	if params[:owner] and params[:owner][:speedlms_subdomain]
  		@subdomain = params[:owner][:speedlms_subdomain]
  	#Checks if the user creating is a tutor.		
  	elsif params[:tutor] and params[:tutor][:speedlms_subdomain] 
  		@subdomain = params[:tutor][:speedlms_subdomain] 
  	end  	
  	if !@subdomain.blank?
  		if Tutor.find_by_speedlms_subdomain(@subdomain) or Owner.find_by_speedlms_subdomain(@subdomain)
  			@message = "Subdomain not available."			
  		else
  			@message = "Subdomain available."
  		end
  	else
  			@message = "Subdomain should not be blank."
  	end 	
  	#Renders message in the specified div according to availability of subdomain.
  	render :update do |page|
  		page.replace_html "subdomain_availability_message", @message
  		page[:subdomain_availability_message].visual_effect(:highlight,
                                  :startcolor => "#88ff88" ,
                                  :endcolor => "#114411")
 		end
  end
    
  #Used to add and invite Tutors by an Owner.
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
       	 #Sends email to Tutor after his/her account has created by Owner.
         email = LoginDetailsMailer.create_sent(@user)
		     email.set_content_type("text/html")
		     LoginDetailsMailer.deliver(email)
         flash[:notice] = "#{@user.login} is added as a tutor"
		     @user = User.new
       end 
     end         
  end  

 private
 
  #Saves Owner and makes him/her current user.
  def successful_signup
    @user.save
	  email = OwnerWelcomeMail.create_sent(@user)
	  email.set_content_type("text/html")
	  OwnerWelcomeMail.deliver(email)
	  flash[:notice] = "Thanks for sign up!"
	  @current_user = @user
    session[:user_id] = @current_user.id
    @owner = Owner.find_by_id(@current_user.resource_id)
    url = @owner.speedlms_url + ownerDesk_path
    redirect_to url
  end 
  
  #This is used to authorize an user to perform actions like Edit/Delete/Destroy on his/her account information.
  def authorize_owner
		owner = Owner.find_by_id(params[:id])
  	unless @current_user.resource == owner
  		flash[:notice] = "You are not authorized to do this."
  		redirect_to ownerDesk_path	
  	end
  end
  
end
