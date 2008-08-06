class CoursesController < ApplicationController
  
  #This makes current user available to all actions .
	before_filter :current_user
	
	#This prevents unauthorized users to access index page.
	before_filter :authorize
	
	#This makes sure that a user can edit,update or destroy only his/her own account.
	# before_filter :authorize_owner, :only => [:edit,:update,:destroy]
	
	#This makes all viewable pages available to all actions.
	# Dont think this is necessary. Thats needed in sessions controler only.
	before_filter :pages
	
	
	def show
	  @course = current_user.resourse.courses.find_by_id(paramd[:id])
	end
	
	def new
	  @course = Course.new
	end
	
	def index
	  @course = Course.new
	  @courses = current_user.resource.courses.find :all
	end

	def create
	  @course = Course.new(params[:course])
	  respond_to do |format|
	  @owner = current_user.resource
      if @owner.courses << @course
        @courses = @owner.courses
        format.html { redirect_to courses_path}
        format.js {
          render :update do |page|
            page.replace_html 'course_list', render(:partial =>@courses)
          end
        }
      else  
        format.html render new_course_path
      end
    end 

  end
  
  def edit
    @course = current_user.resource.courses.find_by_id(params[:id])
    respond_to do |format|
      format.html 
      format.js { render :partial =>'form', :object => @course}
    end
    
  end
  
  def update
    @course = current_user.resource.courses.find_by_id(params[:id])
    @course.update_attributes(params[:course])
     respond_to do |format|
        format.html {render course_path(@course)}
        format.js {
          render :update do |page|
            page.replace dom_id(@course), render(:partial =>'course', :locals =>{:course =>@course})
          end
        }
    end
	end
	
	def destroy
	  @course = current_user.resource.courses.find_by_id(params[:id])
    @course.destroy
    respond_to do |format|
        @courses = current_user.resource.courses
        format.html { redirect_to courses_path}
        format.js {
          render :update do |page|
            page.replace_html 'course_list', render(:partial =>@courses)
          end
        }
    end
	end
	
end
