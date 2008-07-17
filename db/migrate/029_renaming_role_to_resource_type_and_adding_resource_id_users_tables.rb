class RenamingRoleToResourceTypeAndAddingResourceIdUsersTables < ActiveRecord::Migration
  def self.up
  	rename_column :users, :role, :resource_type
  	add_column :users, :resource_id, :integer
  	remove_column :owners, :user_id
  	remove_column :tutors, :user_id
  	remove_column :students, :user_id
  end

  def self.down
  	rename_column :users, :resource_type, :role
  	remove_column :users, :resource_id
  	add_column :owners, :user_id, :integer
  	add_column :tutors, :user_id, :integer
  	add_column :students, :user_id, :integer
  end
end
