class Admin::PagesController < ApplicationController

	#Specifies that the corresponding templates will use 'admin' layout.
	layout 'admin'
	
	#This makes current user available to all actions except new and create.
	before_filter :current_user 
	
	#This makes sure that only Admin can perform Administrative tasks.
  before_filter :authorized_as_admin
  
  #Checks for whether the currently deleting page is an index page or not?
	before_filter :delete_index_page?, :only => [:destroy]
	
	#Includes the features in TinyMCE Editor.
	uses_tiny_mce(:options => {:theme => 'advanced',
                           :browsers => %w{msie gecko},
                           :mode => "specific_textareas",
                           :editor_selector => "mce-editor",
                           :theme_advanced_toolbar_location => "top",
                           :theme_advanced_toolbar_align => "left",
                           :theme_advanced_resizing => true,
                           :theme_advanced_resize_horizontal => false,
                           :height => 300,
                           :width => 400,
                           :paste_auto_cleanup_on_paste => true,
                           :theme_advanced_buttons1 => %w{formatselect fontselect fontsizeselect bold italic 
                           																underline strikethrough separator justifyleft 
                           																justifycenter justifyright indent outdent separator 
                           																bullist numlist forecolor backcolor separator link 
                           																unlink image undo redo},
                           :theme_advanced_buttons2 => [],
                           :theme_advanced_buttons3 => [],
                           :plugins => %w{contextmenu paste}},
              :only => [:new, :edit, :show, :index])	
   
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
