class AddColumnKmToCarmodelOils < ActiveRecord::Migration
  def self.up
    add_column :carmodel_oils, :km, :float
  end

  def self.down
    remove_column :carmodel_oils, :km
  end
end
