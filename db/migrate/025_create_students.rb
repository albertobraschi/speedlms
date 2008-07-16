class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
			t.integer :user_id
			t.string :mobile_number
      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
