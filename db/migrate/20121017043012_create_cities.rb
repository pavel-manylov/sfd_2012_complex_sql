class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.string :local_name
      t.string :state
      t.string :country
      t.timestamps
    end
  end
end
