class CarmodelOil < ActiveRecord::Base
  belongs_to :carmodel
  belongs_to :oil
end