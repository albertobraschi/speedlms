class CreateSignupPlans < ActiveRecord::Migration
  def self.up
    create_table :signup_plans do |t|
      t.string :name
      t.decimal :price, :precision => 5, :scale => 2, :default => 0
      t.integer :time_period
      t.integer :tutors
      t.integer :courses
      t.integer :students
      t.timestamps
    end
  end

  def self.down
    drop_table :signup_plans
  end
end
