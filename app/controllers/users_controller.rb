class UsersController < ApplicationController
	layout 'login'
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
  
  # Displays the index page of the current user who loggs in   
  def index
  	current_user
  	if @current_user
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
  end  
  
  # Creates invoice for a paid plan Owner.
  def payment
  	current_user
  	@plan = SignupPlan.find_by_id(params[:id])
  	@current_user.resource.signup_plan = @plan
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
   	@current_user.resource.update_attributes(:signup_plan_id => @invoice.signup_plan_id)
   	render :action => 'owners/index'
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
	     	flash.now[:notice] = "Notification sent to #{user.email}."
	   	else
	     	flash.now[:notice] = "Please enter a valid email."
	   	end 
	  end
  end
  
  # Used to reset password if user forgot it.
  def reset
  	@user = User.find_by_pcode(params[:pcode]) if params[:pcode]	
  	if @user and request.post?
  		if !params[:user][:password].blank? and !params[:user][:password_confirmation].blank?
				if @user.update_attributes(:password => params[:user][:password],
																	 :password_confirmation => params[:user][:password_confirmation])
					@user.delete_pcode
					flash[:notice] = "Password reset successfully for #{@user.email}"
					redirect_to login_path  				
				end
			else
				flash[:notice] = "Enter password and password_confirmation."
			end  			 			
  	elsif @user.nil?
  		flash.now[:notice] = "Sorry link has expired."
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
							@message = "Username not available."
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
  		page[:username_availability_message].visual_effect(:highlight,
                                 :startcolor => "#88ff88" ,
                                 :endcolor => "#114411")
  	end
	end
	
end	
