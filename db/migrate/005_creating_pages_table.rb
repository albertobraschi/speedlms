class CreatingPagesTable < ActiveRecord::Migration
  def self.up
  	create_table :pages, :force => true do |t|
  	  t.column :title,                     :string
  	  t.column :description,               :string
  	  t.column :is_show,                      :boolean,			:default => 1
  	  t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
  	end
  end

  def self.down
  	drop_table "pages"
  end
end
