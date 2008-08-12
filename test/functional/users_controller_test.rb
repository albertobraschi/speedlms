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
  	assert_response :success
  	assert_tag :tag => 'div', :attributes => {:id => 'notice'}, :parent => {:tag => 'div', :attributes => {:id => 'main_content'}}
  end
  
  def test_forgot_password_with_invalid_email
  	post :forgot, {:user => {:email => 'aaron@gmail.com'}}, {}
		assert_response :success		
  	assert_tag :tag => 'div', :attributes => {:id => 'notice'}, :parent => {:tag => 'div', :attributes => {:id => 'main_content'}}
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
  
  def test_check_username_availability_when_owner_username_is_available
  	xhr :post, :check_username_availability, {:user => {:login => 'steve'}, :owner => {}}, {}
  	assert_equal "Username available.", assigns(:message)
  end
  
   def test_check_username_availability_when_owner_username_is_not_available
  	xhr :post, :check_username_availability, {:user => {:login => 'bill'}, :owner => {}}, {}
  	assert_equal "Username not available.", assigns(:message)
   end
   
   def test_check_username_availability_when_owner_username_is_blank
  	xhr :post, :check_username_availability, {:user => {:login => ''}, :owner => {}}, {}
  	assert_equal "Username should not be blank.", assigns(:message)
   end
   
   def test_check_username_availability_when_tutor_username_is_available
  	xhr :post, :check_username_availability, {:user => {:login => 'steve'}, :tutor => {}}, {:user_id => users(:quentin).id}
  	assert_equal "Username available.", assigns(:message)
   end
  
   def test_check_username_availability_when_tutor_username_is_not_available
  	xhr :post, :check_username_availability, {:user => {:login => 'bill'}, :tutor => {}}, {:user_id => users(:quentin).id}
  	assert_equal "Username not available.", assigns(:message)
   end
   
   def test_check_username_availability_when_tutor_username_is_blank
  	xhr :post, :check_username_availability, {:user => {:login => ''}, :tutor => {}}, {:user_id => users(:quentin).id}
  	assert_equal "Username should not be blank.", assigns(:message)
   end
 
end
