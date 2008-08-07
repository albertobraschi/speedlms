require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users
  
  def test_user_belongs_to_signup_plans
  	plan = SignupPlan.new(:name => 'free')
  	user = User.new(:firstname => 'jitendra', :lastname => 'rai', 
  									:login => 'jitendrarai', :password => 'magadh', 
  									:password_confirmation => 'magadh',:speedlms_subdomain => 'jitendra', 
  									:identity_url => nil, :email => 'jitendra@gmail.com', :role => 'Owner',
  									:organisation => 'vinsol', :timezone => '(UTC + 5:30) New Delhi', 
    								:speedlms_subdomain => 'jitendra', :logo => 'image.jpg')
  	user.signup_plan = plan
  	assert user.valid?
  	assert user.signup_plan, plan
  end
  
  def test_invalid_without_first_and_last_name
  	user = User.new
  	assert !user.valid?
  	assert_equal "can't be blank", user.errors.on(:firstname)
  	assert_equal "can't be blank", user.errors.on(:lastname)
  end

	def test_invalid_without_login_and_email_if_not_openid
		user = User.new(:firstname => 'jitendra', :lastname => 'rai', :identity_url => nil)
		assert !user.valid?
		assert_equal "can't be blank", user.errors.on(:login)
		assert_equal "can't be blank", user.errors.on(:email)
	end

  def test_invalid_with_empty_attributes_for_owner
  	user = User.new(:firstname => 'jitendra', :lastname => 'rai', :login => 'jitendrarai', :email => 'jitendra@gmail.com', :role => 'Owner')
  	assert !user.valid?
  	assert user.errors.invalid?(:signup_plan)
  	assert user.errors.invalid?(:logo)
  	assert user.errors.invalid?(:organisation)
  	assert user.errors.invalid?(:speedlms_subdomain)
  	assert user.errors.invalid?(:timezone)
  end
  
  def test_login_length
  	user = User.new(:firstname => 'jitendra', :lastname => 'rai', :email => 'jitendra@gmail.com')
  	#login should be at least 3 characters long.
  	user.login = 'ab'
  	assert !user.valid?
		assert_equal "is too short (minimum is 3 characters)" , user.errors.on(:login)
		
		user.login = 'abc'
  	assert !user.valid?
  	
  	#login should not exceed 40 characters.
  	user.login = 'aaaaabbbbbcccccdddddeeeeefffffggggghhhhhiiiiijjjjjkkkkk'
  	assert !user.valid?
		assert_equal "is too long (maximum is 40 characters)" , user.errors.on(:login)
  end
  
  def test_password_length
  	user = User.new(:firstname => 'jitendra', :lastname => 'rai', :email => 'jitendra@gmail.com', :login => 'jitendrarai')
  	
  	#password should be at least 3 characters long.
  	user.password = 'aaa'
  	assert !user.valid?
		assert_equal "is too short (minimum is 4 characters)" , user.errors.on(:password)
		
		user.login = 'aaaa'
  	assert !user.valid?
  	
  	#password should not exceed 40 characters.
  	user.password = 'aaaaabbbbbcccccdddddeeeeefffffggggghhhhhiiiiijjjjjkkkkk'
  	assert !user.valid?
		assert_equal "is too long (maximum is 40 characters)" , user.errors.on(:password)
		
  end

	def test_email_format
  	user = User.new(:firstname => 'jitendra', :lastname => 'rai', 
  									:login => 'jitendrarai', :password => 'magadh', 
  									:password_confirmation => 'magadh',:speedlms_subdomain => 'jitendra', 
  									:identity_url => nil)
  	
  	user.email = 'jitendra'
  	assert !user.valid?
		
		user.email = 'jitendra@gmail'
  	assert !user.valid?
  	
  	user.email = 'jitendra@gmail.com.in.uk'
  	assert user.valid?
  	
  	user.email = 'jitendra.vinsol@gmail.com'
  	assert user.valid?
  	
  end
	
	def test_logo_format
  	
  	end
  	
  	bad.each do |name|
    user = User.new(:firstname => "jitendra", :lastname => 'rai', 
    								:login => "jitendrarai", :email => "jitendra@gmail.com",
    								:password => 'magadh', :password_confirmation => 'magadh', 
    								:role => 'Owner', :identity_url => nil,
    								:organisation => 'vinsol', :timezone => '(UTC + 5:30) New Delhi', 
    								:speedlms_subdomain => 'jitendra', :logo => name)
    								
    plan = SignupPlan.new(:name => 'Free')
    user.signup_plan = plan
    assert !user.valid?
  	end
	end

  def test_should_require_login
    assert_no_difference 'User.count' do
      u = create_user(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end
  
  def test_unique_login
  	user = User.new(:login => users(:quentin).login, :firstname => 'jitendra', :lastname => 'rai', :email => 'jitendra@gmail.com')
	  assert !user.save
  	assert_equal ActiveRecord::Errors.default_error_messages[:taken],
             user.errors.on(:login)

	end

	def test_unique_email
  	user = User.new(:email => users(:quentin).email, :firstname => 'jitendra', :lastname => 'rai', :login => 'jitendra')
	  assert !user.save
  	assert_equal ActiveRecord::Errors.default_error_messages[:taken],
             user.errors.on(:email)
	end
	
	def test_unique_speedlms_subdomain
  	user = User.new(:speedlms_subdomain => users(:quentin).speedlms_subdomain, :login => 'jitendra', :firstname => 'jitendra', 
  									:lastname => 'rai', :email => 'jitendra@gmail.com')
	  assert !user.save
  	assert_equal "has already been taken" , user.errors.on(:speedlms_subdomain)
	end

  def test_should_reset_password
   	users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    users(:quentin).update_attributes(:login => 'quentin2')
    assert_equal users(:quentin), User.authenticate('quentin2', 'test')
  end

  def test_should_authenticate_user
    assert_equal users(:quentin), User.authenticate('quentin', 'test')
  end

  def test_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert_equal users(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

protected
  def create_user(options = {})
    record = User.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    record.save
    record
  end
end
