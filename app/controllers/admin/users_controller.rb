class Admin::UsersController < ApplicationController
  layout 'admin'
  before_filter :current_user 
  before_filter :authorized_as_admin
  
  active_scaffold :user do |config|
    config.label = "Users"
    config.columns = [:login,:email,:password,:password_confirmation,:identity_url]
    create.columns.exclude [:identity_url]
    update.columns.exclude [:identity_url]
    list.columns.exclude  [:password,:password_confirmation]
    list.sorting = {:login => 'ASC'}
  end
      
end