class Admin::SignupPlansController < ApplicationController

	#Specifies that the corresponding templates will use 'admin' layout.
  layout 'admin'
  
  #This makes current user available to all actions except new and create.
  before_filter :current_user
  
  #This makes sure that only Admin can perform Administrative tasks. 
  before_filter :authorized_as_admin
  
  #Configures Active Scaffold for various Signup Plans.
  active_scaffold :signup_plan do |config|
    config.label = "SignupPlans"
    config.columns = [:name, :price, :no_of_courses, :time_period, :no_of_tutors, :no_of_students]
    columns[:no_of_courses].label = "Courses"
    columns[:no_of_tutors].label = "Tutors"
    columns[:no_of_students].label = "Students"
    columns[:no_of_tutors].description = "Please enter a number > 10000 to make this field infinite"
    columns[:time_period].description = "Please enter time in months"
    columns[:no_of_courses].description = "Please enter a number > 10000 to make this field infinite"
    columns[:no_of_students].description = "Please enter a number > 10000 to make this field infinite"
  end 
  
end  
