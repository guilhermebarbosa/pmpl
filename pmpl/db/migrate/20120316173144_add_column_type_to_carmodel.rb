class AddColumnTypeToCarmodel < ActiveRecord::Migration
  def self.up
    add_column :carmodels, :carmodel_type, :string
  end

  def self.down
    remove_column :carmodels, :carmodel_type
  end
end
