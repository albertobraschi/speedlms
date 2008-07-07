class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.text :description
      t.float :amount
      t.integer :user_id
      t.integer :signup_plan_id
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
