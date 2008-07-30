class Admin::PagesController < ApplicationController
  
	#Specifies that the corresponding templates will use 'admin' layout.
	layout 'admin'
	
	#This makes current user available to all actions except new and create.
	before_filter :current_user 
	
	#This makes sure that only Admin can perform Administrative tasks.
  before_filter :authorized_as_admin
  
  #Checks for whether the currently deleting page is an index page or not?
	before_filter :delete_index_page?, :only => [:destroy]
  
   
  #Configures Active Scaffold for pages.
	active_scaffold :page do |config|
  config.label = "Pages"
  config.columns = [:title,:description,:is_show, :is_index]
  config.create.columns = [:title,:description,:is_show, :is_index]
  list.columns.exclude [:description]
  list.sorting = {:title => 'DESC'}   
  end
  
  private
  
  #Prevents the index page from being deleted?
  def delete_index_page?
  	@page = Page.find(params[:id])
  	if @page.is_index == true
  		render :update do |page|
  			page.redirect_to :controller => 'admin/pages'
  			flash[:notice] = "You can not delete an index page." 		
  		end
  	end
  end
  
end
