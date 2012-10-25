class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.belongs_to :person
      t.belongs_to :city
      t.date  :date

      t.timestamps
    end
  end
end
