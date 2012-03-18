class CreateVehicles < ActiveRecord::Migration
  def self.up
    create_table :vehicles do |t|
      t.integer :brand_id
      t.integer :carmodel_id
      t.string :license_plate
      t.integer :year
    
      t.timestamps
    end
  end

  def self.down
    drop_table :vehicles
  end
end
