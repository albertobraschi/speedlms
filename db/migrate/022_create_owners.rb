class CreateOwners < ActiveRecord::Migration
  def self.up
    create_table :owners do |t|
			t.string :organisation, :logo, :speedlms_subdomain, :timezone
			t.integer :user_id, :signup_plan_id
      t.timestamps
    end
  end

  def self.down
    drop_table :owners
  end
end
