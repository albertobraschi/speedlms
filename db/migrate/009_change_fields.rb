class ChangeFields < ActiveRecord::Migration
  def self.up
    remove_column :signup_plans, :tutors 
    add_column :signup_plans, :no_of_tutors, :integer
    remove_column :signup_plans, :courses 
    add_column :signup_plans, :no_of_courses, :integer
    remove_column :signup_plans, :students 
    add_column :signup_plans, :no_of_students, :integer 
  end

  def self.down
    add_column :signup_plans, :tutors, :integer 
    remove_column :signup_plans, :no_of_tutors
    add_column :signup_plans, :courses, :integer 
    remove_column :signup_plans, :no_of_courses
    add_column :signup_plans, :students, :integer 
    remove_column :signup_plans, :no_of_students
  end
end
