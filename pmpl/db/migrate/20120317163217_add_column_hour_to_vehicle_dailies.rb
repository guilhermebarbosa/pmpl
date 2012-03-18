class AddColumnHourToVehicleDailies < ActiveRecord::Migration
  def self.up
    add_column :vehicle_dailies, :hour, :float
  end

  def self.down
    remove_column :vehicle_dailies, :hour
  end
end
