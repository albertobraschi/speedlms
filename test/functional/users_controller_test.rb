require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :all

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def	test_index_if_current_user_is_admin 
  	get :index, {}, {:user_id => users(:admin).id}
  	assert_redirected_to admin_users_path
  end
  
  def	test_index_if_current_user_is_owner 
  	get :index, {}, {:user_id => users(:aaron).id}
  	assert_redirected_to owners_path
  end
  
  def	test_index_if_current_user_is_tutor
  	get :index, {}, {:user_id => users(:tutor_1).id}
  	assert_redirected_to tutors_path
  end
  
  def	test_index_if_current_user_is_student
  	get :index, {}, {:user_id => users(:student_1).id}
  	assert_redirected_to students_path
  end
  
  def test_forgot_password_with_valid_email
  	post :forgot, {:user => {:email => 'aaron@example.com'}}, {}
  	#assert_equal "Notification sent to aaron@example.com.", flash.now[:notice]
  	assert_response :success
  end
  
  def test_forgot_password_with_invalid_email
  	post :forgot, {:user => {:email => 'aaron@gmail.com'}}, {}
  	#assert_equal flash.now[:notice], "Please enter a valid email."
  	assert_response :success
  end
  
  def test_reset_password_if_user_exists
  	post :reset, {:pcode => '284e83e2f8c466fbd35eff63acc64d5aed689640', :user => {:password => 'aaaaaa', :password_confirmation => 'aaaaaa'}}, {}
  	assert_equal flash[:notice], "Password reset successfully for bill@gmail.com"
		assert_redirected_to login_path
  end
  
  def test_reset_with_blank_password_and_password_confirmation
  	post :reset, {:pcode => '284e83e2f8c466fbd35eff63acc64d5aed689640', :user => {:password => '', :password_confirmation => ''}}, {}
  	assert_equal flash[:notice], "Enter password and password_confirmation."
  end
  
  def	test_reset_password_without_user
  	post :reset, {:pcode => 'eff63acc64d5aed689640', :user => {:password => 'aaaaaa', :password_confirmation => 'aaaaaa'}}, {}
  	#assert_equal flash.now[:notice], "Sorry link has expired."
  end
  
  def test_delete_user
  	delete :destroy, {:id => 5 }, {:user_id => users(:quentin).id}
  	assert_equal flash[:notice], "User has been deleted"	
  	assert_redirected_to http://quentine.speedlms.dev/owners/add_tutors
  end
	
  #def test_should_allow_signup
    #assert_difference 'User.count' do
     # create_user
      #assert_response :redirect
#    end
 # end

  #def test_should_require_login_on_signup
   # assert_no_difference 'User.count' do
    #  create_user(:login => nil)
     # assert assigns(:user).errors.on(:login)
      #assert_response :success
#    end
 # end

  #def test_should_require_password_on_signup
   # assert_no_difference 'User.count' do
    #  create_user(:password => nil)
     # assert assigns(:user).errors.on(:password)
      #assert_response :success
    #end
#  end

 # def test_should_require_password_confirmation_on_signup
  #  assert_no_difference 'User.count' do
   #   create_user(:password_confirmation => nil)
    #  assert assigns(:user).errors.on(:password_confirmation)
     # assert_response :success
   # end
#  end

 # def test_should_require_email_on_signup
  #  assert_no_difference 'User.count' do
   #   create_user(:email => nil)
    #  assert assigns(:user).errors.on(:email)
     # assert_response :success
    #end
  #end
 
end
