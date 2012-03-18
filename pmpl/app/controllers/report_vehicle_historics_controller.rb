class ReportVehicleHistoricsController < ApplicationController
  before_filter [:load_vehicles]
  before_filter [:load_places]
  before_filter [:load_oils]
  # GET /report_vehicle_historics
  # GET /report_vehicle_historics.xml
  
  def new
    @report_vehicle_historic = ReportVehicleHistoric.new
  end
  def create
    @report_vehicle_historic = ReportVehicleHistoric.new(params[:report_vehicle_historic])
    if @report_vehicle_historic.save
      redirect_to @report_vehicle_historic
    else
      render :action => 'new'
    end
  end
  
  def show
    @report_vehicle_historics = ReportVehicleHistoric.find(params[:id])
  end
  
  private
    def load_vehicles
      @vehicles = Vehicle.select('
        vehicles.id,
        vehicles.license_plate
      ').joins("
        INNER JOIN carmodels ON carmodels.id = vehicles.carmodel_id
        INNER JOIN carmodel_oils co ON co.carmodel_id = carmodels.id
        INNER JOIN oils ON oils.id = co.oil_id
        LEFT JOIN vehicle_historics vh ON vh.vehicle_id = vehicles.id AND vh.oil_id = oils.id
      ").find(:all, :conditions => ["
          ( 
        	(
        	SELECT
        		vhis.status
        	FROM
        		vehicle_historics vhis
        	WHERE
        		vhis.vehicle_id = vehicles.id 
        	AND 
        		vhis.oil_id = oils.id
        	ORDER BY
        		vhis.status
        	LIMIT
        		0,1
        	) = 'aberto'
          )"], :group => "vehicles.id").collect { |c| [c.license_plate, c.id] }
    end
    def load_places
      @places = Place.all.collect { |c| [c.name, c.id] }
    end
    def load_oils
      @oils = Oil.find(:all, :order => "name").collect { |c| [c.name, c.id] }
    end
end
