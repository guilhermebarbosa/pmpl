class Carmodel < ActiveRecord::Base
  belongs_to :brand
  
  has_many :vehicles, :dependent => :destroy
  has_many :carmodel_oils, :dependent => :delete_all
  has_many :oils, :through => :carmodel_oils
  
  validates :brand_id, :name, :carmodel_type, :presence => true
  
  accepts_nested_attributes_for :carmodel_oils, :reject_if => lambda { |a| a[:km].blank? and a[:hour].blank? }, :allow_destroy => true

  Type = ["Caminhão", "Maquina"]
end