class ChangingPlanToSignupplanInUsersTable < ActiveRecord::Migration
  def self.up
  	remove_column :users, :plan
  	add_column :users, :SignupPlan_id, :integer
  end

  def self.down
  	remove_column :users, :SignupPlan_id
  	add_column :users, :plan, :string
  end
end
