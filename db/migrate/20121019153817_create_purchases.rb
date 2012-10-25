class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :payment_system
      t.float :sum
      t.belongs_to :client

      t.timestamps
    end
  end
end
