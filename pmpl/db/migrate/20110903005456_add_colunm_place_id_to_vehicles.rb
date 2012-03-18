class AddColunmPlaceIdToVehicles < ActiveRecord::Migration
  def self.up
    add_column :vehicles, :place_id, :integer
  end

  def self.down
    remove_column :vehicles, :place_id
  end
end