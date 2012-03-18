class AddColumnEmailToVehicleHistorics < ActiveRecord::Migration
  def self.up
    add_column :vehicle_historics, :email, :boolean, :default => false
  end

  def self.down
    remove_column :vehicle_historics, :email
  end
end