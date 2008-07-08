require File.dirname(__FILE__) + '/../test_helper'

class SignupPlanTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_for_signup_plan_has_many_users
  	user1 = users(:abra)
  	user2 = users(:laloo)
  	plan = signup_plans(:one)
  	assert_equal user1.signup_plan.name, plan.name
  	assert_equal user2.signup_plan.name, plan.name
  end
  
  def test_for_find_plans
  	#there are two plans in signup_plans fixture
  	plans = SignupPlan.find_plans
  	assert_equal plans.size, 2
  	assert_equal plans[0].name, 'plan1'
  	assert_equal plans[1].name, 'plan2'  	
  end
  
end
