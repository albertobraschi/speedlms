class SignupPlan < ActiveRecord::Base

	#Sets a constant INFINITE_DEFINITION to 10000.
  INFINITE_DEFINITION = 10000
  has_many :owners
  
  #Find available Sign up plans.
  def self.find_plans
	  find(:all, :order => 'price ASC')
	end
	
	#Sets quantity of an entity to unlimited.
	def is_unlimited?
	  if @signup_plan.no_of_tutors > INFINITE_DEFINITION
	    return true
	  else
	    return false  
	  end  
	end  
	
end
