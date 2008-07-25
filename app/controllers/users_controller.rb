class UsersController < ApplicationController

	#This makes various methods of Restful_Authentication available to all actions of Users Controller.
	include AuthenticatedSystem
	
	#This makes various methods of Active Merchant available to all actions of Users Controller.
	include ActiveMerchant::Billing
  
  #This prevents unauthorized users to access index page.
	before_filter :authorize, :only=>[:index]
	
	#This makes all viewable pages available to all actions.
	before_filter :pages
	
	#If the actions are confirm and notify,It skips the verify_authenticity_token filter.
  skip_before_filter :verify_authenticity_token, :only=> [:confirm, :notify]   
  
	# Makes a new instance of user.
  	def new
  		#Firstly checks for if there is someone logged in.
  		if current_user
    		flash[:notice] = "Firstly logout and then create new user"
			if current_user.is_admin?      		
     			redirect_to admin_users_path and return 
     		else     		
     			redirect_to users_path and return
     		end
    	end
	    @user = User.new() 
  	  	render :layout => 'public'
  	end
  
  	# Creates a new user.  
  	def create
    	cookies.delete :auth_token 
    	@user = User.new(params[:user])
    	@user.role = User::ROLE[:owner]
    	@price = SignupPlan.find_by_id(@user.signup_plan_id).price if @user.signup_plan_id
    	if @user.valid?
    		#FREE is a constant and equal to 0.0
    		if @price == FREE
    			successful_signup()
    		else
   				redirect_to(:action => "payment",:id => @user.signup_plan_id)
   			end
   		else
   			render :action => 'new',:layout => 'public'
   		end
  	end
  
  	# Displays the index page of the current user who loggs in   
  	def index
  		current_user
    	render :action => "#{@current_user.resource_type.downcase}_index" if @current_user.resource_type
  	end  

  	# Checks Subdomain 
  	#def check_subdomain
  		#@users = User.find(:all)
  	#end
  
  	# Creates invoice for a paid plan Owner.
  	def payment
  		current_user
  		@plan = SignupPlan.find_by_id(@current_user.plan)
  		@invoice = Invoice.new
  		@invoice.signup_plan = @plan
  		@invoice.user = @current_user
  		@invoice.amount = @plan.price
  		@invoice.status = "Payment due"
  		@invoice.save!
  	end
  
  	# Notifies the Owner after successful transaction on Paypal.
  	def notify
    	notify = Paypal::Notification.new(request.raw_post)
    	plan = Plan.find(notify.item_id)
    	if notify.acknowledge
      		@payment = Payment.find_by_confirmation(notify.transaction_id) ||
        	invoice.payments.create(:amount => notify.amount,
          	:payment_method => 'paypal', :confirmation => notify.transaction_id,
          	:description => notify.params['item_name'], :status => notify.status,
          	:test => notify.test?)
      		begin
        	if notify.complete?
          		@payment.status = notify.status
        	else
          		logger.error("Failed to verify Paypal's notification, please investigate")
        	end
      		rescue => e
        		@payment.status = 'Error'
        	raise
      		ensure
        	@payment.save
      		end
    	end
    	render :nothing => true
  	end
  	
  	# Confirm Invoice details worked
  	def confirm
    	if @invoice = Invoice.find(params[:id])
      		@invoice.confirm
      		flash[:notice] = "Payment made successfully via paypal."
      		InvoiceMailor.deliver_confirmation(@invoice)
    	else
      		flash[:message] = "Not a valid URL."
    	end
    	render :action => "#{@current_user.resource_type.downcase}_index" if @current_user.resource_type
  	end
  
  	# Used to sent confirm mail if user forgot password.
  	def forgot
	   	if request.post?
	     	user = User.find_by_email(params[:user][:email])
	      	if user
	        	user.generate_pcode
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
  
  	# Used to reset password if user forgot it.
  	def reset
   		@user = User.find_by_pcode(params[:pcode]) unless params[:pcode].nil?
    	if @user.nil?
      	flash[:notice] = "Sorry this link has expired"
      	redirect_back_or_default('/')
      elsif request.post?
       	if @user.update_attributes(:password => params[:user][:password], 
       														 :password_confirmation => params[:user][:password_confirmation])
          @user.delete_pcode
          flash[:notice] = "Password reset successfully for #{@user.email}"
          redirect_back_or_default('/')
        end
     	end
  	end
  	
  	# Deletes the Tutor from an Owner's account.
  	def destroy
  		current_user
	  	@user = User.find(params[:id])
	  	@tutor = @user.resource
	  	@user.destroy
	  	@tutor.destroy
	  	redirect_to @current_user.resource.speedlms_url + add_tutors_owners_path
	  	flash[:notice] = "User has been deleted"	
  	end
  
  	# Checks availability of Owner's login 
  	def check_username_availability
  		@username = params[:user][:login]
  		@users = User.find(:all)
  		if !@username.blank?
  			if @users.blank?
  				@message = "Username available."
  			else
  				@users.each do |user|
  					#Checks for Owner's login availability.
  					if params[:owner]
							if @username == user.login				
								@message = "Username not available"
								break
							else
								@message = "Username available."
							end	
						#Checks for Tutor's login availability.																											
						elsif params[:tutor]
							current_user
							@owner = current_user.resource
							@tutors = Tutor.find(:all, :conditions => ["owner_id = ?",@owner.id])
							#@Tutor_users should not remain nil while using with << method.
							@tutor_users = []
							if @tutors
								@tutors.each do |tutor|
									@tutor_users << tutor.user
								end
							end	
							#Finds all Users who are not Tutor.						
							@non_tutors = User.find(:all, :conditions => ["resource_type != ?",'Tutor'])
							#Combines two arrays (@tutor_users and @non_tutors) into one array and checks if login available.
							for user in @tutor_users.concat(@non_tutors) 				
								if params[:user][:login] == user.login
									@message = "Username not available."
									break
								else
									@message = "Username available."
								end
							end							
						end															
					end
  			end
  		else
  			@message = "Username should not be blank."
  		end
  		#Renders message in the specified div according to availability of login.
  		render :update do |page|
  		page.replace_html 'username_availability_message',@message
  		end
		end
		
end	
