class SessionsController < ApplicationController
	include AuthenticatedSystem
	before_filter :login_from_cookie, :only => [:new,:create] 
	before_filter :current_user 

	def new
  
	end
  
	def create
		if using_open_id?

			open_id_authentication
		else
			password_authentication(params[:name], params[:password])       
		end
	end
      
	def destroy
		@current_user.forget_me if logged_in?
		cookies.delete :auth_token
		reset_session
		flash[:message] = "You are successfully logout."
		respond_to do |format|
			format.html {redirect_to new_session_path}
			format.js
		end
	end
                            
	protected
		def password_authentication(name, password)
			if @current_user =User.authenticate(params[:name], params[:password])
				successful_login
			else
				failed_login "Sorry, Invaild login."
			end
		end

		def open_id_authentication 
   
			authenticate_with_open_id do |result, identity_url|
		
			if result.successful?
	
				if @current_user = User.find_or_create_by_identity_url(identity_url)
		
					successful_login
				else
					failed_login "Sorry, no user by that identity URL exists (#{identity_url})"
				end
			else
				failed_login result.message
			end
		end
	end
        
	private
	def successful_login
	 
		session[:user_id] = @current_user.id 
	
		if logged_in?

			if params[:remember_me] 

				@current_user.remember_me unless @current_user.remember_token?
				cookies[:auth_token] = { :value => @current_user.remember_token , :expires => @current_user.remember_token_expires_at }

			end     

			flash[:notice] = "Logged in successfully"
			respond_to do |format|
				format.html {redirect_to users_path}
				format.js
			end
		else
			render :action => 'new'
		end    
	end

	def failed_login(message)
		flash[:error] = message
		respond_to do |format|
			format.html {redirect_to new_session_url}
			format.js
		end
	end
	
end
