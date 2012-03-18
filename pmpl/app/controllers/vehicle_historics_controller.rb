class VehicleHistoricsController < ApplicationController
  before_filter [:load_vehicles], :only=>[:new, :edit, :create, :update]
  before_filter [:load_oils], :only=>[:new, :edit]
  
  # GET /vehicle_historics
  # GET /vehicle_historics.xml
  def index
    
    @vehicle_historics_exchange = VehicleHistoric.select("
    veh.license_plate,
    pla.name as place_name,
    oil.name,
    SUM(day.km) as km_atual,
    cmod_oil.km,
    vehicle_historics.id,
    vehicle_historics.date,
    vehicle_historics.km_initial
    ").joins("
    INNER JOIN
    	vehicles veh ON veh.id = vehicle_historics.vehicle_id
    INNER JOIN
      places pla ON pla.id = veh.place_id
    INNER JOIN
        carmodels cmod ON cmod.id = veh.carmodel_id
    INNER JOIN
        oils oil ON oil.id = vehicle_historics.oil_id
    INNER JOIN
        carmodel_oils cmod_oil ON cmod_oil.carmodel_id = cmod.id AND cmod_oil.oil_id = oil.id
    LEFT JOIN
        vehicle_dailies day ON day.vehicle_id = veh.id
    ").where("
      vehicle_historics.status = 'aberto'
    ").group("
    vehicle_historics.id, vehicle_historics.oil_id
    ").having("
      vehicle_historics.km_initial + (km_atual - vehicle_historics.km_initial) >= vehicle_historics.km_initial + cmod_oil.km
    ")
    
    @vehicle_historics_warning = VehicleHistoric.select("
    veh.license_plate,
    pla.name as place_name,
    oil.name,
    SUM(day.km) as km_atual,
    cmod_oil.km,
    vehicle_historics.id,
    vehicle_historics.date,
    vehicle_historics.km_initial,
    cmod_oil.km_warning
    ").joins("
    INNER JOIN
    	vehicles veh ON veh.id = vehicle_historics.vehicle_id
    INNER JOIN
      places pla ON pla.id = veh.place_id
    INNER JOIN
        carmodels cmod ON cmod.id = veh.carmodel_id
    INNER JOIN
        oils oil ON oil.id = vehicle_historics.oil_id
    INNER JOIN
        carmodel_oils cmod_oil ON cmod_oil.carmodel_id = cmod.id AND cmod_oil.oil_id = oil.id
    LEFT JOIN
        vehicle_dailies day ON day.vehicle_id = veh.id
    ").where("
      vehicle_historics.status = 'aberto'
    ").group("
    vehicle_historics.id, vehicle_historics.oil_id
    ").having("
      vehicle_historics.km_initial + (km_atual - vehicle_historics.km_initial) < vehicle_historics.km_initial + cmod_oil.km 
    AND 
      vehicle_historics.km_initial + (km_atual - vehicle_historics.km_initial) + cmod_oil.km_warning >= vehicle_historics.km_initial + cmod_oil.km
    ")
    
    @vehicle_historics_daily = VehicleHistoric.select("
    veh.license_plate,
    pla.name as place_name,
    oil.name,
    IF(day.km != '', SUM(day.km), '0') as km_atual,
    cmod_oil.km,
    vehicle_historics.id,
    vehicle_historics.date,
    vehicle_historics.km_initial,
    cmod_oil.km_warning,
    day.id as day_id
    ").joins("
    INNER JOIN
    	vehicles veh ON veh.id = vehicle_historics.vehicle_id
    INNER JOIN
      places pla ON pla.id = veh.place_id
    INNER JOIN
        carmodels cmod ON cmod.id = veh.carmodel_id
    INNER JOIN
        oils oil ON oil.id = vehicle_historics.oil_id
    INNER JOIN
        carmodel_oils cmod_oil ON cmod_oil.carmodel_id = cmod.id AND cmod_oil.oil_id = oil.id
    LEFT JOIN
        vehicle_dailies day ON day.vehicle_id = veh.id
    ").where("
      vehicle_historics.status = 'aberto'
    ").group("
    vehicle_historics.id, vehicle_historics.oil_id
    ").having("
      (vehicle_historics.km_initial + (km_atual - vehicle_historics.km_initial) + cmod_oil.km_warning < vehicle_historics.km_initial + cmod_oil.km)
    OR
      (day_id is null)
    ")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vehicle_historics }
    end
  end
  
  def update_oil_select    

      @oils = Vehicle.select('
        oils.id,
        oils.name
      ').joins("
        INNER JOIN carmodels ON carmodels.id = vehicles.carmodel_id
        INNER JOIN carmodel_oils co ON co.carmodel_id = carmodels.id
        INNER JOIN oils ON oils.id = co.oil_id
        LEFT JOIN vehicle_historics vh ON vh.vehicle_id = vehicles.id AND vh.oil_id = oils.id
      ").find(:all, :conditions => ["vehicles.id = '#{params[:id]}'   AND
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
        	) != 'aberto'
          OR
            vh.id is null
          )"], :group => "oils.id")
      render :partial => "oil", :oils => @oils
  end
  
  def exchange
    @vehicle_historic = VehicleHistoric.find(params[:id])
    
    @vehicle_historic.date = Time.zone.now
    @vehicle_historic.status = "fechado"
    
    @vehicle_historic.save
    
    @km_initial = VehicleDaily.select("
    CASE
      WHEN SUM(vehicle_dailies.km) is null THEN '0'
      WHEN SUM(vehicle_dailies.km) is not null THEN SUM(vehicle_dailies.km) 
     END as km_atual,
    vehicle_dailies.id
    ").find(:first, :conditions => ["
      vehicle_dailies.vehicle_id = '#{@vehicle_historic.vehicle_id}'
    "])
    
    @new_vehicle_historic = VehicleHistoric.new
    @new_vehicle_historic.vehicle_id = @vehicle_historic.vehicle_id
    @new_vehicle_historic.oil_id = @vehicle_historic.oil_id
    @new_vehicle_historic.status = "aberto"
    @new_vehicle_historic.km_initial = @km_initial.km_atual
    @new_vehicle_historic.save
    
    redirect_to(vehicle_historics_url)
  end

  # GET /vehicle_historics/1
  # GET /vehicle_historics/1.xml
  def show
    @vehicle_historic = VehicleHistoric.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vehicle_historic }
    end
  end

  # GET /vehicle_historics/new
  # GET /vehicle_historics/new.xml
  def new
    @vehicle_historic = VehicleHistoric.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vehicle_historic }
    end
  end

  # GET /vehicle_historics/1/edit
  def edit
    @vehicle_historic = VehicleHistoric.find(params[:id])
  end

  # POST /vehicle_historics
  # POST /vehicle_historics.xml
  def create
    @vehicle_historic = VehicleHistoric.new(params[:vehicle_historic])
    @vehicle_historic.status = "aberto"
    
    @km_initial = VehicleDaily.select("
    CASE
      WHEN SUM(vehicle_dailies.km) is null THEN '0'
      WHEN SUM(vehicle_dailies.km) is not null THEN SUM(vehicle_dailies.km) 
     END as km_atual,
    vehicle_dailies.id
    ").find(:first, :conditions => ["
      vehicle_dailies.vehicle_id = '#{@vehicle_historic.vehicle_id}'
    "])

    @vehicle_historic.km_initial = @km_initial.km_atual  
    
    respond_to do |format|
      if @vehicle_historic.save
        format.html { redirect_to(@vehicle_historic, :notice => 'Vehicle historic was successfully created.') }
        format.xml  { render :xml => @vehicle_historic, :status => :created, :location => @vehicle_historic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vehicle_historic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vehicle_historics/1
  # PUT /vehicle_historics/1.xml
  def update
    @vehicle_historic = VehicleHistoric.find(params[:id])
    @vehicle_historic.status = "aberto"

    respond_to do |format|
      if @vehicle_historic.update_attributes(params[:vehicle_historic])
        format.html { redirect_to(@vehicle_historic, :notice => 'Vehicle historic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vehicle_historic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicle_historics/1
  # DELETE /vehicle_historics/1.xml
  def destroy
    @vehicle_historic = VehicleHistoric.find(params[:id])
    @vehicle_historic.destroy

    respond_to do |format|
      format.html { redirect_to(vehicle_historics_url) }
      format.xml  { head :ok }
    end
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
          carmodels.carmodel_type = 'Caminhão'
          AND
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
          	) != 'aberto'
            OR
              vh.id is null
          )"], :group => "vehicles.id").collect { |c| [c.license_plate, c.id] }
    end
    
    def load_oils
      @oils = Array.new
    end
end
