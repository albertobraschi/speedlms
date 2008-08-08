class TutorsController < ApplicationController
  #This prevents unauthorized users to access index page.
	before_filter :authorize
  #This makes current user available to all actions .
	before_filter :current_user
	before_filter :current_tutor, :only =>[]
	def index
	  @courses = @tutor.courses
	end
	
	
	
	private
	def current_tutor
	  resource = @current_user.resource
	  if resource.class == Tutor
	    @tutor = resource
	  else
	    flash[:message]= "This action is only allowed for tutor."
	    redirect_to courses_url
    end
    
	end
end
