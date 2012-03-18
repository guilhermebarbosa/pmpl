class CreateMachineHistorics < ActiveRecord::Migration
  def self.up
    create_table :machine_historics do |t|
      t.references :vehicle
      t.references :oil
      t.float :hour_initial
      t.date :date
      t.text :observation
      t.boolean :email, :default => false
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :machine_historics
  end
end
