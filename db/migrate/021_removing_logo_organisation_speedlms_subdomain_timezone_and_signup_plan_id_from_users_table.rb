class RemovingLogoOrganisationSpeedlmsSubdomainTimezoneAndSignupPlanIdFromUsersTable < ActiveRecord::Migration
  def self.up
  	remove_column :users,	:organisation
  	remove_column :users,	:logo
  	remove_column :users,	:speedlms_subdomain
  	remove_column :users,	:timezone
  	remove_column :users,	:mobile_phone
  	remove_column :users,	:signup_plan_id
  end

  def self.down
  	add_column :users,	:organisation, :string
  	add_column :users,	:logo, :string
  	add_column :users,	:speedlms_subdomain, :string
  	add_column :users,	:timezone, :string
  	add_column :users,	:mobile_phone, :string
  	add_column :users,	:signup_plan_id, :integer
  end
end
