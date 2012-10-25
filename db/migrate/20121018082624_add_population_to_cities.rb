class AddPopulationToCities < ActiveRecord::Migration
  def change
    add_column :cities, :population, :integer
  end
end
