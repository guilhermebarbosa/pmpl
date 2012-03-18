class CreateCarmodelOils < ActiveRecord::Migration
  def self.up
    create_table :carmodel_oils, :id => false do |t|
      t.references :carmodel, :null => false
      t.references :oil, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :carmodel_oils
  end
end
