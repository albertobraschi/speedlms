require File.dirname(__FILE__) + '/../test_helper'
require 'owners_controller'

# Re-raise errors caught by the controller.
class OwnersController; def rescue_action(e) raise e end; end

class OwnersControllerTest < ActionController::TestCase

	fixtures :users,:owners,:signup_plans
	
	def setup
    @controller = OwnersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_index_without_owner
    get :index
    assert_redirected_to :action => "new", :controller => 'sessions'
		assert_equal "Please login" , flash[:notice]
  end
  
  def test_index_with_owner
    get :index, {}, { :user_id => users(:quentin).id}
    assert_response :success
    assert_template "index"
  end
  
  def test_new_with_current_user_as_admin
  	get :new, {}, {:user_id => users(:admin).id}
    assert_redirected_to admin_users_path
    assert_equal "Firstly logout and then create.", flash[:notice]
  end
  
  def test_new_with_current_user_as_owner
  	get :new, {}, {:user_id => users(:quentin).id}
    assert_redirected_to owners_path
    assert_equal "Firstly logout and then create.", flash[:notice]
  end
  
  def test_new_with_current_user_as_tutor
  	get :new, {}, {:user_id => users(:tutor_1).id}
    assert_redirected_to tutors_path
    assert_equal "Firstly logout and then create.", flash[:notice]
  end
  
  def test_new_with_current_user_as_student
  	get :new, {}, {:user_id => users(:student_1).id}
    assert_redirected_to students_path
    assert_equal "Firstly logout and then create.", flash[:notice]
  end
  
  def test_new_without_current_user
  	get :new
  	assert_response :success
    assert_template "new"
  end
  
  def test_create_with_valid_owner_with_free_signup_plan
  	post :create, {:user  => {:password_confirmation => "raju", :firstname => "raju", :lastname => "singh", :login => "raju", :password => "raju", :email => "raju@gmail.com"},  
  	:owner => {:timezone => "International Date Line West", :signup_plan_id => "3", :logo => "", :organisation => "raj", :speedlms_subdomain => "raju"}}, {:signup_plan => signup_plans(:free)}
  	assert_equal "Thanks for sign up!", flash[:notice]  	
  end
  
  def test_create_with_valid_owner_with_paid_signup_plan
  	post :create, {:user  => {:password_confirmation => "raju", :firstname => "raju", :lastname => "singh", :login => "raju", :password => "raju", :email => "raju@gmail.com"},  
  	:owner => {:timezone => "International Date Line West", :signup_plan_id => "1", :logo => "", :organisation => "raj", :speedlms_subdomain => "raju"}}, {:signup_plan => signup_plans(:one)}
  	assert_redirected_to :action => 'payment'
  end
  
  def test_create_without_valid_owner
  	post :create, {:speedlms_subdomain => ''}, {}
  	assert_template 'new'
  end
  
  def test_edit_owner
  	get :edit, {:id => '1'}, {:user_id => users(:quentin).id}
  	assert_template 'edit'
  	assert_response :success
  end
  
  def test_update_valid_owner
  	post :update, {:id => '1', :user => {:id => '1', :firstname => 'kquentin'}}, {:user_id => users(:quentin).id}
  	assert_equal "User was sucessfully updated", flash[:notice]
  	assert_redirected_to owners_url
  end
  
  def test_update_invalid_owner
  	post :update, {:id => '1', :user => {:id => '1', :email => 'invalid'}}, {:user_id => users(:quentin).id}
  	assert_template 'edit'
  end
  
  #def test_add_tutors
  	#post :add_tutors, {:id => '1',:tutor => {"speedlms_subdomain"=>"aaaaaaa"}, :user => {:password_confirmation => "aaaaa", :firstname =>"aaaaa", :lastname =>"aaaa", :login => "aaaaa", :password => "aaaaa", :email => "aaa11@gmail.com"}}, {:user_id => users(:quentin).id}
  	#assert_equal "raju is added as a tutor", flash[:notice]  	
  #end
  
  #def test_check_availability_of_subdomain
  	#post, :check_subdomain_availability, {:owner => {:speedlms_subdomain => 'aaron'}}, {}
  	#assert_equal "Subdomain should not be blank", @message
  #end
 
end
