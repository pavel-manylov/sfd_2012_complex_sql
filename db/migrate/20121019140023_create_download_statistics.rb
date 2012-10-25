class CreateDownloadStatistics < ActiveRecord::Migration
  def change
    create_table :download_statistics do |t|
      t.integer :ip
      t.integer :file_id
      t.integer :year_in_tz, :month_in_tz, :day_in_tz, :hour_in_tz, :minute_in_tz


      t.timestamps
    end

    add_index :download_statistics, [:file_id, :ip, :year_in_tz, :month_in_tz, :day_in_tz, :hour_in_tz, :minute_in_tz], :name=>"with_date"
  end
end
