class UsersController < ApplicationController
	include AuthenticatedSystem
	include ActiveMerchant::Billing
  
	before_filter :authorize, :only=>[:index]
	before_filter :current_user, :except=>[:new, :create]
  skip_before_filter :verify_authenticity_token, :only=> [:confirm, :notify]  
  
	#Makes a new instance of user.
  def new
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
  
  #Creates a new user.  
  def create
    cookies.delete :auth_token 
    @user = User.new(params[:user])
    @user.role = User::ROLE[:owner]
    @price = SignupPlan.find_by_id(@user.signup_plan_id).price if @user.signup_plan_id
    if @user.valid?
    	#FREE is a constant and equal to 0.0
    	if @price == FREE
    		successful_signup
    	else
   			redirect_to :action => "payment",:id => @user.signup_plan_id
   		end
   	else
   		render :action => 'new',:layout => 'public'
   	end
  end
  
  #Displays the index page of the current user who loggs in   
  def index
    render :action => "#{@current_user.role.downcase}_index" if @current_user.role
  end  
    
  #sets @user variable
  def edit 
    @id = User.find(params[:id]).id
    if @current_user.id == @id 
      @user = User.find(params[:id]) 
    else
      render :text => "Sorry you cannot edit this user"  
    end  
  end
  
  #checks 
  def check_subdomain
  	@users = User.find(:all)
  end
  
  #Creates invoice for a paid plan user.
  def payment
  	@plan = SignupPlan.find_by_id(@current_user.plan)
  	@invoice = Invoice.new
  	@invoice.signup_plan = @plan
  	@invoice.user = @current_user
  	@invoice.amount = @plan.price
  	@invoice.status = "Payment due"
  	@invoice.save!
  end
  
  #Notifies the user after successful transaction on Paypal.
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
  
  def confirm
    if @invoice = Invoice.find(params[:id])
      @invoice.confirm
      flash[:notice] = "Payment made successfully via paypal."
      InvoiceMailor.deliver_confirmation(@invoice)
    else
      flash[:message] = "Not a valid URL."
    end
    render :action => "#{@current_user.role.downcase}_index" if @current_user.role
  end
  
  #Updates the fields of user
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
       flash[:notice] = "User was sucessfully updated"
       format.html { redirect_to users_url}
      else  
       format.html {render :action => "edit"}
      end
    end    
  end  
  
  #Used to sent confirm mail if user forgot password.
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
  
  #Used to reset password if user forgot it.
  def reset
   @user = User.find_by_pcode(params[:pcode]) unless params[:pcode].nil?
    if @user.nil?
      flash[:notice] = "Sorry this link has expired"
      redirect_back_or_default('/')
      elsif request.post?
        if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
          @user.delete_pcode
          flash[:notice] = "Password reset successfully for #{@user.email}"
          redirect_back_or_default('/')
        end
     end
  end
  
  #Used to add and invite tutors.
  def add_tutors
	 @tutors = User.find(:all, :conditions => ["role = ? ",  "Tutor"])
    if request.post?
	    @user = User.new(params[:user])
      @user.role = User::ROLE[:tutor] 
       if @user.save
         email = LoginDetailsMailer.create_sent(@user)
		     email.set_content_type("text/html")
		     LoginDetailsMailer.deliver(email)
         flash[:notice] = "#{@user.login} is added as a tutor"
		     @user = User.new
       end 
     end         
  end  

  #checks availability of username for owner  
  def check_username_availability
  	@username = params[:user][:login]
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
  	@subdomain = params[:user][:speedlms_subdomain]
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
  
  #deletes the user from the list of all users
  def destroy
	  @user = User.find(params[:id])
	  @user.destroy
	  redirect_to @current_user.speedlms_url + add_tutors_users_path
	  flash[:notice] = "User has been deleted"	
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
    redirect_to @current_user.speedlms_url + users_path(:sess => session[:user_id])
  end 
   
end
