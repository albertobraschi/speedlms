require File.dirname(__FILE__) + '/../test_helper'
require 'sessions_controller'
include OpenIdAuthentication
# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end

class SessionsControllerTest < ActionController::TestCase
	fixtures :all
	
	def setup
    @controller = SessionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
	
	def test_index
    get :index
    assert_response :success
		assert_template 'index'
  end
  
  def test_view_pages_without_current_subdomain
		get :view_pages, {}, {}
		assert_response :success
		assert_template 'view_pages'		
	end
	
	def test_new_with_current_user_as_owner
		get :new, {}, {:user_id => users(:aaron).id}
		assert_redirected_to ownerDesk_path
		assert_equal "You are already logged in - YAHOO", flash[:notice]
	end
	
	def test_new_with_current_user_as_tutor
  	get :new, {}, {:user_id => users(:tutor_1).id}
    assert_redirected_to tutors_path
    assert_equal "You are already logged in - YAHOO", flash[:notice]
  end
  
  def test_new_with_current_user_as_student
  	get :new, {}, {:user_id => users(:student_1).id}
    assert_redirected_to students_path
    assert_equal "You are already logged in - YAHOO", flash[:notice]
  end
  
  def test_new_with_current_user_as_admin
  	get :new, {}, {:user_id => users(:admin).id}
    assert_redirected_to admin_users_path
    assert_equal "You are already logged in - YAHOO", flash[:notice]
  end
  
  def test_new_without_current_user
  	get :new
  	assert_response :success
    assert_template "new"
  end
  
  #Tests which are dependent on current_subdomain will be write later on.
  #def test_create_new_session_with_username_password
 		#self.request.subdomains = ['bill']
  	#post :create, {:name => 'bill', :password => 'billbill'}, {}
  	#assert_equal "Logged in successfully", flash[:notice]
  #end
  
  def test_session_destroy
  	delete :destroy, {}, {:user_id => users(:aaron).id}
  	assert_equal "You are successfully logged out.", flash[:notice]
  	assert_redirected_to root_path
  end
	
end
