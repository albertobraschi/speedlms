class Admin::SignupPlansController < ApplicationController
  layout 'admin'
  before_filter :current_user 
  before_filter :authorized_as_admin
  active_scaffold :signup_plan do |config|
    config.label = "SignupPlans"
    config.columns = [:name, :price, :no_of_courses, :time_period, :no_of_tutors, :no_of_students]
    columns[:no_of_courses].label = "Courses"
    columns[:no_of_tutors].label = "Tutors"
    columns[:no_of_students].label = "Students"
    columns[:no_of_tutors].description = "Please enter a number > 10000 to make this field infinite"
  end 
  
end  