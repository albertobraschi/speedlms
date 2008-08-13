class RenamingDefaultPageToHomePage < ActiveRecord::Migration
  def self.up
  	page = Page.find_by_title("Default Page")
  	page.update_attributes(:title => 'Home')
  end

  def self.down
  	page = Page.find_by_title("Home")
  	page.update_attributes(:title => 'Default Page')
  end
end
