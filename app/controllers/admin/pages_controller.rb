class Admin::PagesController < ApplicationController
	layout 'admin'
	before_filter :current_user 
  before_filter :authorized_as_admin
	active_scaffold :page do |config|
    config.label = "Pages"
    config.columns = [:title,:description,:is_show]
    list.columns.exclude [:description]
    list.sorting = {:title => 'DESC'}
  end 
end
