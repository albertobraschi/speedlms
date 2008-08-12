class Page < ActiveRecord::Base
	validates_presence_of :title,:description
	validates_uniqueness_of :title
	
	#Finds collection of those pages which admin wants to show('is_show' = true)
	def self.find_viewable_pages
	  find(:all, :conditions => ["is_show = ?",1])
	end
	
	#Finds that page which is set as index page by admin
	def self.find_index_page
		find(:first, :conditions => "is_index = 1")
	end
	
	#Callback which checks for previous index page and updates it's 'is_index' attribute to false,if admin creates a new index page
	def before_create
		if self.is_index == true
			page = Page.find(:first, :conditions => ["is_index = ?",1])
			page.update_attributes(:is_index => 0) if page
		end
	end
	
	#Callback which checks for previous index page and updates it's 'is_index' attribute to false,if admin upgrades an existing page as index page.
	def before_update
		if self.is_index == true
			page = Page.find(:first, :conditions => ["is_index = ?",1])
			page.update_attributes(:is_index => 0) if page
		end
	end
	
end
