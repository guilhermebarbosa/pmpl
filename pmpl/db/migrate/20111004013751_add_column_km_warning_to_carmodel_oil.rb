class AddColumnKmWarningToCarmodelOil < ActiveRecord::Migration
  def self.up
    add_column :carmodel_oils, :km_warning, :float
  end

  def self.down
    remove_column :carmodel_oils, :km_warning
  end
end
