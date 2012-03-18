class MachineHistoric < ActiveRecord::Base
  belongs_to :vehicle
  belongs_to :oil
  has_many :vehicle_dailies
  
  validates :status, :vehicle_id, :oil_id, :presence => true
end
