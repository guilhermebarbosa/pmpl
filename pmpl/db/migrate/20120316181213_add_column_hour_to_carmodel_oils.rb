class AddColumnHourToCarmodelOils < ActiveRecord::Migration
  def self.up
    add_column :carmodel_oils, :hour, :float
    add_column :carmodel_oils, :hour_warning, :float
  end

  def self.down
    remove_column :carmodel_oils, :hour_warning
    remove_column :carmodel_oils, :hour
  end
end
