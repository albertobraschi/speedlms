class RemoveColumnPrice < ActiveRecord::Migration
  def self.up
    remove_column :signup_plans, :price
  end

  def self.down
    add_column :signup_plans, :price, :decimal, :precision => 5, :scale => 2, :default => 0
  end
end
