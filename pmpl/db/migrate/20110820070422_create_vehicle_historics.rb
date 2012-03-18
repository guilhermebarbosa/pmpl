class CreateVehicleHistorics < ActiveRecord::Migration
  def self.up
    create_table :vehicle_historics do |t|
      t.references :vehicle
      t.references :oil
      t.float :km_initial
      t.date :date
      t.text :observation
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :vehicle_historics
  end
end
