class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :subject
      t.belongs_to :client
      t.string :initiator_type
      t.integer :initiator_id
      t.timestamps
    end
  end
end
