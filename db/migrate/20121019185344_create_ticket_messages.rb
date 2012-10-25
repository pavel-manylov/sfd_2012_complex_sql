class CreateTicketMessages < ActiveRecord::Migration
  def change
    create_table :ticket_messages do |t|
      t.belongs_to :ticket
      t.string :sender_type
      t.integer :sender_id
      t.string :message

      t.timestamps
    end
  end
end
