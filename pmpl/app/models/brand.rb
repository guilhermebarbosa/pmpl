class Brand < ActiveRecord::Base
  has_many :vehicles, :dependent => :destroy
  has_many :carmodels, :dependent => :destroy
  
  validates :name, :presence => true
end