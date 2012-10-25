class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.belongs_to :city_of_birth
      t.string :name
      t.timestamps
    end
  end
end
