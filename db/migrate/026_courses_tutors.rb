class CoursesTutors < ActiveRecord::Migration
  def self.up
  	create_table :courses_tutors, :id => false do |t|
  		t.integer :course_id, :tutor_id
  	end
  end

  def self.down
  	drop_table :courses_tutors
  end
end
