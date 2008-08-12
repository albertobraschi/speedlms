require File.dirname(__FILE__) + '/../test_helper'

class OwnerTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :all
  
  def test_owners_belongs_to_signup_plan
  	plan = signup_plans(:one)
  	user1 = users(:quentin)
  	owner1 = owners(:quentin)
    								
		user2 = users(:aaron)
		owner2 = owners(:aaron)				    					
  	
  	assert user1.valid?
  	assert user2.valid?
  	assert owner1.valid?
  	assert owner2.valid?
  	assert owner1.signup_plan, owner2.signup_plan
  end
  
  def test_owner_has_one_user
  	owner1 = owners(:quentin)
    user1 = users(:quentin)
    assert_equal owner1.user, user1
  	user2 = User.new(:firstname => 'madan', :lastname => 'mohan', :login => 'madanmohan', :email => 'madan@gmail.com', :password => '123456', :password_confirmation => '123456')
  	user2.resource = owner1
  	assert_not_equal owner1.user, user2
  end
  
  def test_owner_has_many_courses
  	owner1 = owners(:quentin)
  	course1 = courses(:physics)
  	course2 = courses(:chemistry)
  	course3 = courses(:math)
  	assert_equal course1.owner, course2.owner, course3.owner
  end
  
  def test_owner_has_many_tutors
  	owner1 = owners(:quentin)
  	tutor1 = tutors(:tutor_1)
  	tutor2 = tutors(:tutor_2)
  	assert_equal owner1.speedlms_subdomain, tutor1.owner.speedlms_subdomain, tutor2.owner.speedlms_subdomain
  end
  
  def test_presence_of_signup_plan_and_speedlms_subdomain_and_organisation_and_timezone
  	owner = Owner.new(:logo => 'image1.jpg')
		assert !owner.valid?
		assert_equal "is must for Owner", owner.errors.on(:signup_plan)
		assert_equal "is must for Owner", owner.errors.on(:speedlms_subdomain)
		assert_equal "is must for Owner", owner.errors.on(:organisation)
		assert_equal "is must for Owner", owner.errors.on(:timezone)
  end
  
  def test_logo_format
  	ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
           http://a.b.c/x/y/z/fred.gif }
  	bad = %w{ fred.doc fred.gif/more fred.gif.more }
  	
  	ok.each do |name|                                       
    	user = users(:quentin)
    	owner = owners(:quentin) 
    	owner.logo = name  								
    	plan = signup_plans(:one)
    	owner.signup_plan = plan
    	assert user.valid?
  	end
  	
  	bad.each do |name|
		  user = users(:quentin)
    	owner = owners(:quentin)
    	owner.logo = name    								
    	plan = signup_plans(:one)
   	 	user.resource = owner
    	owner.signup_plan = plan
    	assert !user.valid?
		end

  end
  
  def test_uniqueness_of_subdomain
  	owner = Owner.new(:speedlms_subdomain => owners(:quentin).speedlms_subdomain, :organisation => 'vspl', :timezone => '(UTC + 5:30) New Delhi',:signup_plan_id => 1)
	  assert !owner.save
  	assert_equal "should be unique", owner.errors.on(:speedlms_subdomain)
  end
  
  
end
