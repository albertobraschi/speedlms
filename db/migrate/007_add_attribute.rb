class AddAttribute < ActiveRecord::Migration
  def self.up
    add_column :users, :pcode, :string, :limit => 40
  end

  def self.down
    remove_column :users, :pcode
  end
end
