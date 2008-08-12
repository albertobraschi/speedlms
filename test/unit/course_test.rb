require File.dirname(__FILE__) + '/../test_helper'

class CourseTest < ActiveSupport::TestCase

  fixtures :all
  
  def test_course_require_name_and_description 
  	c1 = Course.new(:name => '', :description => '', :status => 'complete', :display_quick_navigation_dropdown => true, :owner_id => 1)
  	assert !c1.valid?
  	assert_equal "can't be blank", c1.errors.on(:name)
  	assert_equal "can't be blank", c1.errors.on(:description)
  end
  
  def test_uniqueness_of_course_name
  	c1 = courses(:physics)
  	c2 = Course.new(:name => courses(:physics).name)
  	assert !c2.valid?
  	assert_equal "has already been taken", c2.errors.on(:name)
  end
  
  #def test_includes_tutor?
  	
  #end
  
end
