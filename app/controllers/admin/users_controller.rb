class Admin::UsersController < ApplicationController
  layout 'admin'
  active_scaffold :user do |config|
    config.label = "Users"
    config.columns = [:login,:email,:password,:password_confirmation,:identity_url]
    create.columns.exclude [:identity_url]
    update.columns.exclude [:identity_url]
    list.columns.exclude  [:password,:password_confirmation]
    list.sorting = {:login => 'ASC'}
  end  
end
