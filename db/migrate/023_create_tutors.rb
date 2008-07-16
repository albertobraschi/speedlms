class CreateTutors < ActiveRecord::Migration
  def self.up
    create_table :tutors do |t|
			t.string :speedlms_subdomain
			t.integer :user_id, :owner_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tutors
  end
end
