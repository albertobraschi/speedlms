class Admin::SignupPlansController < ApplicationController
  layout 'admin'
  before_filter :current_user 
  before_filter :authorized_as_admin
  active_scaffold :signup_plan do |config|
    config.label = "SignupPlans"
    config.columns = [:name, :price, :courses, :time_period, :tutors, :students]
  end  
end  