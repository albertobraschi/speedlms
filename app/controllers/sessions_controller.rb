class SessionsController < ApplicationController
    def create
      if using_open_id?
        open_id_authentication
      else
        password_authentication(params[:name], params[:password])
      end
    end
    
    def destroy
      session[:user_id] = nil
      flash[:message] = "You are successfully logout."
      redirect_to new_session_path
    end

    protected
      def password_authentication(name, password)
        if @current_user =User.authenticate(params[:name], params[:password])
          successful_login
        else
          failed_login "Sorry, that username/password doesn't work"
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
        flash[:notice] = "Logged in successfully"
        redirect_to users_path
        #redirect_back_or_default(index_url)
        #redirect_to(root_url)
      end

      def failed_login(message)
        flash[:error] = message
        redirect_to(new_session_url)
      end
end
