require File.dirname(__FILE__) + '/../test_helper'

class StudentTest < ActiveSupport::TestCase
  fixtures :all
  
  def test_user_has_one_student_as_resource
  	student = students(:student_1)
  	user = users(:student_1)
  	assert_equal student.user, user
  end
  
  def test_student_has_and_belongs_to_many_courses 
  	s1 = students(:student_1)
  	s2 = students(:student_2)
  	c1 = courses(:physics)
  	c2 = courses(:chemistry)
  	assert_equal s1.courses[0], s2.courses[1]
  	assert_equal c1.students[0], c2.students[1]
  end
  
end
