class Owner < ActiveRecord::Base
	belongs_to :signup_plan
	has_one :user, :as => :resource, :dependent=>:destroy 
	has_many :courses
	has_many :tutors
	
	attr_accessible :signup_plan_id, :timezone, :logo, :organisation, :speedlms_subdomain
	
	validates_presence_of     :signup_plan ,:speedlms_subdomain, :organisation, :timezone,
  													:message => "is must for Owner"
	validates_format_of 			:logo, 
														:with => %r{\.(gif|jpg|png)$}i,
														:if => Proc.new{|a| a.logo.length > 0 if a.logo}
  validates_uniqueness_of   :speedlms_subdomain,
  													:if => Proc.new{|a| a.speedlms_subdomain.length > 0 if a.speedlms_subdomain}, 
  													:message => "should be unique"
  
 	#Creates speedlms url for an owner after he signs up.
	def	speedlms_url
			speedlms_url = "http://#{self.speedlms_subdomain}.speedlms.dev"
	end
	
	def validate  													
	
	end
end
