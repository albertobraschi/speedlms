class ChangingTypeOfDescriptionFieldInAdminPagesToText < ActiveRecord::Migration
  def self.up
    remove_column :pages, :description
    add_column :pages, :description, :text
  end

  def self.down
    remove_column :pages, :description
    add_column :pages, :description, :string
  end
end
