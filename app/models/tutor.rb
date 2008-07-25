class Tutor < ActiveRecord::Base
	belongs_to :owner
	has_many :users, :as => :resource, :dependent=>:destroy 	
	has_and_belongs_to_many :courses
	
	#validates_uniqueness_of :login, :scope => :owner_id
end
