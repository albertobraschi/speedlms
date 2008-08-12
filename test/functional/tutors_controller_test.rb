require File.dirname(__FILE__) + '/../test_helper'
require 'tutors_controller'

# Re-raise errors caught by the controller.
class TutorsController; def rescue_action(e) raise e end; end

class TutorsControllerTest < ActionController::TestCase
  
  fixtures :users,:owners,:tutors,:courses
	
	def setup
    @controller = TutorsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_index_with_non_tutor_user
  	get :index, {}, {:user_id => users(:aaron).id}
  	assert_equal flash[:message], "This action is only allowed for tutor."
		assert_redirected_to courses_path
  end
  
  def test_index_with_tutor_user
  	get :index, {}, {:user_id => users(:tutor_1).id}
		assert_template 'index'
  end
  
end
