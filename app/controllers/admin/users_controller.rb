class Admin::UsersController < ApplicationController

	#Specifies that the corresponding templates will use 'admin' layout.
  layout 'admin'
  
  #This makes current user available to all actions except new and create.
  before_filter :current_user 
  
  #This makes sure that only Admin can perform Administrative tasks. 
  before_filter :authorized_as_admin
  
  #Configures Active Scaffold for various Signup Plans.
  active_scaffold :user do |config|
    config.label = "Users"
    config.columns = [:login,:email,:password,:password_confirmation,:identity_url]
    create.columns.exclude [:identity_url]
    update.columns.exclude [:identity_url]
    list.columns.exclude  [:password,:password_confirmation]
    list.sorting = {:login => 'ASC'}
  end   
end
