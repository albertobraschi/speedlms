class Tutor < ActiveRecord::Base
	belongs_to :owner	
	has_and_belongs_to_many :courses
	has_one :user, :as => :resource, :dependent=>:destroy 
	validates_uniqueness_of :login, :scope => :owner_id
end
