class SignupPlan < ActiveRecord::Base
  INFINITE_DEFINITION = 10000
  has_many :users
  @signup_plan = SignupPlan.new
  
  def self.find_plans
	  find(:all, :order => 'price ASC')
	end
	
	def is_unlimited?
	  if @signup_plan.no_of_tutors > INFINITE_DEFINITION
	    return true
	  else
	    return false  
	  end  
	end  
	
end
