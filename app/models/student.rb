class Student < ActiveRecord::Base
	has_and_belongs_to_many :courses
	has_one :user, :as => :resource
end
