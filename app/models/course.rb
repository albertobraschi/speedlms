class Course < ActiveRecord::Base
	belongs_to :owner
	has_and_belongs_to_many :tutors
	has_and_belongs_to_many :students
end
