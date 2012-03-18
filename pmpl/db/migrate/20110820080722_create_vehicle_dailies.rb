class CreateVehicleDailies < ActiveRecord::Migration
  def self.up
    create_table :vehicle_dailies do |t|
      t.references :vehicle
      t.float :km
      t.date :date

      t.timestamps
    end
  end

  def self.down
    drop_table :vehicle_dailies
  end
end
