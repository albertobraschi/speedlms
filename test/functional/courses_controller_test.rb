require File.dirname(__FILE__) + '/../test_helper'
require 'courses_controller'

# Re-raise errors caught by the controller.
class CoursesController; def rescue_action(e) raise e end; end

class CoursesControllerTest < ActionController::TestCase

	fixtures :users,:owners,:signup_plans
	
	def setup
    @controller = OwnersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_index_with_owner_current_user
  	get :index, {}, {:user_id => users(:aaron).id}
  	assert_response :success
  	assert_template 'index'
  end  
	
	def test_index_with_non_owner_current_user
  	get :index, {}, {:user_id => users(:tutor_1).id}
		assert_redirected_to courses_path
		assert_equal flash[:message], "This action is only allowed to owner."
  end  
	
	def test_index_without_current_user
  	get :index, {}, {}
		assert_redirected_to new_session_path
		assert_equal flash[:notice], "Please login"
  end
  
  def test_create_course_with_valid_parameters
  	xhr :post, :create, {:tutors => ['1'], :course => {:name => 'zoology', :description => 'animal classification', :status => 'complete', :display_quick_navigation_dropdown => true, :owner_id => 1}}, {:user_id => users(:aaron).id} 	
  	assert_response :success  	
  end

  #def test_create_course_with_invalid_parameters
  	#xhr :post, :create, {:tutors => ['1'], :course => {:name => '', :description => 'animal classification', :status => 'complete', :display_quick_navigation_dropdown => true, :owner_id => 1}}, {:user_id => users(:aaron).id} 	
  	#assert_response :success  	
  #end
  
  def test_edit_course
  	xhr :post, :show, {:id => 1}, {:user_id => users(:aaron).id}
  	assert_response :success
  end
  
  def test_update_course_with_valid_parameters
  	xhr :post, :show, {:id => 1, :course => {:name => 'botany'}}, {:user_id => users(:aaron).id}
  	assert_response :success
  end	
  
  #def test_update_course_with_invalid_parameters
  	#xhr :post, :show, {:id => 1, :course => {:name => ''}}, {:user_id => users(:aaron).id}
  	#assert_response :success
  #end	
	  
  def test_show_course
  	xhr :post, :show, {:id => 1}, {:user_id => users(:aaron).id}
  	assert_response :success
  end	 
  
  def test_destroy_course
  	xhr :post, :show, {:id => 1}, {:user_id => users(:aaron).id}
  	assert_response :success
  end
	  
end
