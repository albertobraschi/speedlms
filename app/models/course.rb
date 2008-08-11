class Course < ActiveRecord::Base
	belongs_to :owner
	has_and_belongs_to_many :tutors
	has_and_belongs_to_many :students
	
	validates_presence_of :name, :description
	
	
	def includes_tutor?(tutor_id)
	  if self.new_record?
	    return false
	  else
	    t = self.tutors.find(tutor_id) rescue nil
	    return !t.nil?
    end
	end
end
