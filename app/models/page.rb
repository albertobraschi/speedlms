class Page < ActiveRecord::Base
	validates_presence_of :title,:description
	validates_uniqueness_of :title
	
	def self.find_viewable_pages
	  find(:all, :conditions => "is_show = 1")
	end
	
end
