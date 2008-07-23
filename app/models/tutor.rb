class Tutor < ActiveRecord::Base
	belongs_to :owner
	has_one :user, :as => :resource, :dependent=>:destroy 	
	has_and_belongs_to_many :courses
end
