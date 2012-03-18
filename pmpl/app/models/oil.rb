class Oil < ActiveRecord::Base
  has_many :vehicle_historics, :dependent => :destroy
  has_many :carmodel_oils, :dependent => :destroy
  has_many :carmodels, :through => :carmodel_oils
    
  accepts_nested_attributes_for :carmodel_oils
  
  validates :name, :presence => true
end
