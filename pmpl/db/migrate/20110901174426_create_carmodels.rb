class CreateCarmodels < ActiveRecord::Migration
  def self.up
    create_table :carmodels do |t|
      t.references :brand
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :carmodels
  end
end
