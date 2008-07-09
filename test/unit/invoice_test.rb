require File.dirname(__FILE__) + '/../test_helper'

class InvoiceTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_invoice_belongs_to_user
  	user1 = users(:quentin)
  	invoice = invoices(:one)
  	assert_equal invoice.user.login, user1.login
  end
  
  def test_invoice_belongs_to_signup_plan
  	plan = signup_plans(:one)
  	invoice = invoices(:one)
  	assert_equal invoice.signup_plan.name, plan.name
  end
  
  def test_update_attribute
  	invoice = invoices(:one)
  	assert_equal invoice.status, "Payment due"
  	invoice.status = 'Confirmed'
    assert invoice.save
  	assert_equal invoice.status, "Confirmed"
  end
  
end
