class AddingFollowingFieldsToUsersTableOrganisationLogoSpeedlmsUrlTimeZoneMobilePhone < ActiveRecord::Migration
  def self.up
  	add_column :users, :organisation, :string
  	add_column :users, :logo, 				:string
  	add_column :users, :speedlms_url, :string
  	add_column :users, :timezone,			:string
  	add_column :users, :mobile_phone, :string
  end

  def self.down
  	remove_column :users, :organisation
  	remove_column :users, :logo
  	remove_column :users, :speedlms_url
  	remove_column :users, :timezone
  	remove_column :users, :mobile_phone
  end
end
