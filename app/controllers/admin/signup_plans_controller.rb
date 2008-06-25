class Admin::UsersController < ApplicationController
  layout 'admin'
  before_filter :current_user 
  before_filter :authorized_as_admin
  active_scaffold :signup_plan
end  