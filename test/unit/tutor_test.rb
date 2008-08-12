require File.dirname(__FILE__) + '/../test_helper'

class TutorTest < ActiveSupport::TestCase
  
  fixtures :all
  
  def test_tutors_belong_to_owner
  	tutor1 = tutors(:tutor_1)
  	tutor2 = tutors(:tutor_2)
  	owner = owners(:quentin)
  	assert_equal tutor1.owner, tutor2.owner
  end
  
  def test_user_has_one_tutor_as_resource
  	tutor1 = tutors(:tutor_1)
  	user = users(:tutor_1)
  	assert_equal tutor1.user.resource_type, "Tutor"
  	assert_equal tutor1.id, user.resource_id
  end
  
  def test_tutor_has_and_belongs_to_many_courses
  	t1 = tutors(:tutor_1)
  	t2 = tutors(:tutor_2)
  	c1 = courses(:physics)
  	c2 = courses(:chemistry)
  	assert_equal t1.courses[0], t2.courses[1]
  	assert_equal c1.tutors[0], c2.tutors[1]  	
  end
  
  def test_speedlms_subdomain_required
  	tutor = Tutor.new(:speedlms_subdomain => '')
  	owner = owners(:quentin)
  	user = User.new(:firstname => 'jitendra', :lastname => 'rai', 
  									:login => 'jitendrarai', :password => 'magadh', 
  									:password_confirmation => 'magadh', :speedlms_subdomain => 'jitendra', 
  									:email => 'jitendra@gmail.com', :resource_type => 'Tutor')
  	tutor.owner = owner
  	user.resource = tutor
  	assert !tutor.valid?
  	assert_equal "can't be blank", tutor.errors.on(:speedlms_subdomain)
  end
  
  def test_uniqueness_of_speedlms_subdomain
  	tutor1 = tutors(:tutor_1)
  	owner = owners(:quentin)
  	tutor2 = Tutor.new(:speedlms_subdomain => tutors(:tutor_1).speedlms_subdomain)
  	user1 = User.new(:firstname => 'jitendra', :lastname => 'rai', 
  									:login => 'jitendrarai', :password => 'magadh', 
  									:password_confirmation => 'magadh', :speedlms_subdomain => 'jitendra', 
  									:email => 'jitendra@gmail.com', :resource_type => 'Tutor')
  	tutor2.owner = owner
  	user1.resource = tutor2
  	assert !tutor2.valid?
  	assert_equal "has been already taken.", tutor2.errors.on(:speedlms_subdomain)
  end
  
  def test_speedlms_subdomain_for_tutors
  	tutor1 = tutors(:tutor_1)
  	assert tutor1.valid?
  	assert_equal tutor1.speedlms_subdomain, "tutor1"
  	assert_equal tutor1.speedlms_url, 'http://tutor1.speedlms.dev'
  end
  
end
