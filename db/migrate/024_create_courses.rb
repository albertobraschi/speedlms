class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
			t.string :name, :status
			t.text :description
			t.boolean :display_quick_navigation_dropdown
      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
