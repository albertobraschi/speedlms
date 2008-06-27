class Admin::PagesController < ApplicationController
	layout 'admin'
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
	before_filter :current_user 
  before_filter :authorized_as_admin
	active_scaffold :page do |config|
  config.label = "Pages"
  config.columns = [:title,:description,:is_show]
  list.columns.exclude [:description]
  list.sorting = {:title => 'DESC'}   
  end
    
end
