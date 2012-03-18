class Vehicle < ActiveRecord::Base
  has_many :vehicle_historics, :dependent => :destroy
  has_many :vehicle_dailies, :dependent => :delete_all
  belongs_to :brand
  belongs_to :carmodel
  belongs_to :place

  validates :license_plate, :place_id, :brand_id, :carmodel_id, :year, :presence => true
end
