class CreateReportVehicleHistorics < ActiveRecord::Migration
  def self.up
    create_table :report_vehicle_historics do |t|
      t.integer :vehicle_id
      t.integer :place_id
      t.integer :oil_id
      t.date :initial_date
      t.date :end_date
      t.string :status
      t.timestamps
      
      t.timestamps
    end
  end

  def self.down
    drop_table :report_vehicle_historics
  end
end
