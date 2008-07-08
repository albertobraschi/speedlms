require File.dirname(__FILE__) + '/../test_helper'

class PageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_invalid_without_title_and_description
  	page = Page.new
  	assert !page.valid?
  	assert_equal "can't be blank", page.errors.on(:title)
  	assert_equal "can't be blank", page.errors.on(:description)
  end
  
  def test_unique_title
  	page = Page.new(:title => pages(:one).title, :description => 'pages makes a book')
	  assert !page.save
  	assert_equal ActiveRecord::Errors.default_error_messages[:taken], page.errors.on(:title)
	end
	
	def test_for_find_viewable_pages
	#fixture pages.yml contains two instance of page.
		page = Page.find_viewable_pages
		assert_equal page.size, 2
	end
		
end
