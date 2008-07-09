class AddingIsIndexToPages < ActiveRecord::Migration
  def self.up
  	add_column :pages, :is_index, :boolean, :default => 0
  end

  def self.down
  	remove_column :pages, :is_index
  end
end
