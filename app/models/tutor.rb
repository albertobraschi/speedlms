class Tutor < ActiveRecord::Base
	belongs_to :owner
	has_one :user, :as => :resource, :dependent=>:destroy 	
	has_and_belongs_to_many :courses
	
	validates_presence_of 	:speedlms_subdomain
	validates_uniqueness_of :speedlms_subdomain,
													:if => Proc.new{|a| a.speedlms_subdomain.length > 0 if a.speedlms_subdomain}, 
  												:message => "has been already taken."
  												
  #Creates speedlms url for an owner after he signs up.
  def	speedlms_url
    speedlms_url = "http://#{self.speedlms_subdomain}.speedlms.dev"
  end
    												
end
