require File.dirname(__FILE__) + '/../test_helper'

class SignupPlanTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_for_signup_plan_has_many_owners
  	owner1 = owners(:john)
  	owner2 = owners(:quentin)
  	plan = signup_plans(:one)
  	assert_equal owner1.signup_plan.name, plan.name
  	assert_equal owner2.signup_plan.name, plan.name
  end
  
  def test_for_find_plans
  	#there are two plans in signup_plans fixture
  	plans = SignupPlan.find_plans
  	assert_equal plans.size, 3
  	assert_equal plans[0].name, 'plan3'
  	assert_equal plans[1].name, 'plan1'  
  	assert_equal plans[2].name, 'plan2'  	
  end
  
end
