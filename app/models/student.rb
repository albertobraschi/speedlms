class Student < ActiveRecord::Base
	has_and_belongs_to_many :courses
	has_many :users, :as => :resource, :dependent=>:destroy 
end
