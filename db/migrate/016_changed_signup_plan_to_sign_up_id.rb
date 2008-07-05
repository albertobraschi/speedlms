class ChangedSignupPlanToSignUpId < ActiveRecord::Migration
  def self.up
  	rename_column :users, :SignupPlan_id, :signup_plan_id
  end

  def self.down
  	rename_column :users, :signup_plan_id, :SignupPlan_id
  end
end
