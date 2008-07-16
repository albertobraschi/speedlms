class CoursesStudents < ActiveRecord::Migration
  def self.up
  	create_table :courses_students, :id => false do |t|
  		t.integer :course_id, :student_id
  	end
  end

  def self.down
  	drop_table :courses_students
  end
end
