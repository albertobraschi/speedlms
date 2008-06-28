class AddColumnPriceWithPrecision6 < ActiveRecord::Migration
  def self.up
    add_column :signup_plans, :price, :decimal, :precision => 6, :scale => 2, :default => 0
  end

  def self.down
    remove_column :signup_plans, :price
  end
end
