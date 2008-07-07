class ChangingSpeedlmsUrlToSpeedlmsSubdomain < ActiveRecord::Migration
  def self.up
  	rename_column :users, :speedlms_url, :speedlms_subdomain
  	
  end

  def self.down
  	rename_column :users, :speedlms_subdomain, :speedlms_url
  end
end
