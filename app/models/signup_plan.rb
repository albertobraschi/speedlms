class SignupPlan < ActiveRecord::Base
  has_many :users
  
  def self.find_plans
	  find(:all, :order => 'price ASC')
	end
	
end
