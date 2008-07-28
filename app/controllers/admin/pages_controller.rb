class Admin::PagesController < ApplicationController
	
	require 'json'
  include Spelling 
  
	#Specifies that the corresponding templates will use 'admin' layout.
	layout 'admin'
	
	#This makes current user available to all actions except new and create.
	before_filter :current_user 
	
	#This makes sure that only Admin can perform Administrative tasks.
  before_filter :authorized_as_admin
  
  #Checks for whether the currently deleting page is an index page or not?
	before_filter :delete_index_page?, :only => [:destroy]
	
	uses_tiny_mce(:options => {:theme => 'advanced',
                           :browsers => %w{msie gecko},
                           :mode => "specific_textareas",
                           :editor_selector => "mce-editor",
                           :theme_advanced_toolbar_location => "top",
                           :theme_advanced_toolbar_align => "left",
                           :theme_advanced_resizing => true,
                           :theme_advanced_resize_horizontal => false,
                           :height => 400,
                           :width => 500,
                           :paste_auto_cleanup_on_paste => true,
                           :theme_advanced_buttons1 => %w{bold italic underline strikethrough justifyleft 
                           																justifycenter justifyright forecolor backcolor spellchecker},
													 :theme_advanced_buttons2 => [],
												   :theme_advanced_buttons3 => [],                           																
                           :plugins => %w{preview paste contextmenu spellchecker},
 													 :spellchecker_languages => "+English=en,Espanol=es",
 													 :spellchecker_rpc_path => "home/spellchecker"
 													 })	   
   
  #Configures Active Scaffold for pages.
	active_scaffold :page do |config|
  config.label = "Pages"
  config.columns = [:title,:description,:is_show, :is_index]
  config.create.columns = [:title,:description,:is_show, :is_index]
  list.columns.exclude [:description]
  list.sorting = {:title => 'DESC'}   
  end
  
  
  def spellchecker
  p "fdjsgjsgjjjjdsjyhiudhjhj"
    headers["Content-Type"] = "text/plain"
    headers["charset"] =  "utf-8"
    suggestions = check_spelling(params[:params][1], params[:method], params[:params][0])
    results = {"id" => nil, "result" => suggestions, 'error' => nil}
    render :text => results.to_json
    return
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
