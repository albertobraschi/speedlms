class UsersController < ApplicationController
	include AuthenticatedSystem
	before_filter :authorize,:only => :index
	before_filter :current_user, :only => :index
	
  def new
    @user = User.new() 
    render :layout => 'public'
  end
  
  def create
    cookies.delete :auth_token 
    @user = User.new(params[:user])
    @user.role = User::ROLE[:owner]
    @price = SignupPlan.find_by_id(@user.signup_plan_id).price if @user.signup_plan_id
    if @user.valid?
    	if @price == 0.0
    		successful_signup
    	else
   			redirect_to :action => "payment",:id => @user.signup_plan_id
   		end
   	else
   		render :action => 'new',:layout => 'public'
   	end
  end
     
  def index
    render :action => "#{@current_user.role.downcase}_index" if @current_user.role
  end  
  
  def edit 
    @current_user = User.find(params[:id])
  end
  
  def payment
  	@signup_plan = SignupPlan.find_by_id(params[:id])
  	render :layout => 'public'
  	#call "successful_signup" here.....to save user after return from paypal.
  	#successful_signup
  end
  
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
  
  def forgot
   if request.post?
     user = User.find_by_email(params[:user][:email])
      if user
        user.pcode = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join )
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
  
  def add_tutors
    @user = User.new(params[:user])
    @user.role = User::ROLE[:tutor]
    @user.save
    flash[:notice] = "#{@user.login} is added as tutor"
  end
  
  private
  def successful_signup 
      @user.save
	  	flash[:notice] = "Thanks for sign up!"
	  	@current_user = @user
    	session[:user_id] = @current_user.id
    	render :action => "owner_index"
  end
   
end