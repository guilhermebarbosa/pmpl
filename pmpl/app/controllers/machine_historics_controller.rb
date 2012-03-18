class MachineHistoricsController < ApplicationController
  before_filter [:load_vehicles], :only=>[:new, :edit, :create, :update]
  before_filter [:load_oils], :only=>[:new, :edit]
  
  # GET /vehicle_historics
  # GET /machine_historics.xml
  def index
    
    @machine_historics_exchange = MachineHistoric.select("
    veh.license_plate,
    pla.name as place_name,
    oil.name,
    SUM(day.km) as km_sum,
    SUM(day.hour) as hour_sum,
    cmod_oil.km,
    cmod_oil.hour,
    machine_historics.id,
    machine_historics.date,
    machine_historics.hour_initial
    ").joins("
    INNER JOIN
    	vehicles veh ON veh.id = machine_historics.vehicle_id
    INNER JOIN
      places pla ON pla.id = veh.place_id
    INNER JOIN
        carmodels cmod ON cmod.id = veh.carmodel_id
    INNER JOIN
        oils oil ON oil.id = machine_historics.oil_id
    INNER JOIN
        carmodel_oils cmod_oil ON cmod_oil.carmodel_id = cmod.id AND cmod_oil.oil_id = oil.id
    LEFT JOIN
        vehicle_dailies day ON day.vehicle_id = veh.id
    ").where("
      machine_historics.status = 'aberto'
    ").group("
    machine_historics.id, machine_historics.oil_id
    ").having("
      (
         	machine_historics.hour_initial + ((km_sum * cmod_oil.hour / cmod_oil.km + hour_sum) - machine_historics.hour_initial) >= machine_historics.hour_initial + cmod_oil.hour
  	  )
  	  OR
      (
  	      cmod_oil.km is null
  	    AND 
         	machine_historics.hour_initial + (hour_sum - machine_historics.hour_initial) >= machine_historics.hour_initial + cmod_oil.hour
  	  )
    ")
    
    @machine_historics_warning = MachineHistoric.select("
    veh.license_plate,
    pla.name as place_name,
    oil.name,
    SUM(day.km) as km_sum,
    SUM(day.hour) as hour_sum,
    cmod_oil.km,
    cmod_oil.hour,
    machine_historics.id,
    machine_historics.date,
    machine_historics.hour_initial,
    cmod_oil.hour_warning
    ").joins("
    INNER JOIN
    	vehicles veh ON veh.id = machine_historics.vehicle_id
    INNER JOIN
      places pla ON pla.id = veh.place_id
    INNER JOIN
        carmodels cmod ON cmod.id = veh.carmodel_id
    INNER JOIN
        oils oil ON oil.id = machine_historics.oil_id
    INNER JOIN
        carmodel_oils cmod_oil ON cmod_oil.carmodel_id = cmod.id AND cmod_oil.oil_id = oil.id
    LEFT JOIN
        vehicle_dailies day ON day.vehicle_id = veh.id
    ").where("
      machine_historics.status = 'aberto'
    ").group("
    machine_historics.id, machine_historics.oil_id
    ").having("
      (
          machine_historics.hour_initial + ((km_sum * cmod_oil.hour / cmod_oil.km + hour_sum) - machine_historics.hour_initial) < machine_historics.hour_initial + cmod_oil.hour 
        AND 
         	machine_historics.hour_initial + ((km_sum * cmod_oil.hour / cmod_oil.km + hour_sum) - machine_historics.hour_initial) + cmod_oil.hour_warning >= machine_historics.hour_initial + cmod_oil.hour
  	  )
  	  OR
      (
  	    cmod_oil.km is null
  	  AND
  	  	machine_historics.hour_initial + (hour_sum - machine_historics.hour_initial) < machine_historics.hour_initial + cmod_oil.hour 
      AND 
      	machine_historics.hour_initial + (hour_sum - machine_historics.hour_initial) + cmod_oil.hour_warning >= machine_historics.hour_initial + cmod_oil.hour
  	  )
    ")
    
    @machine_historics_daily = MachineHistoric.select("
    veh.license_plate,
    pla.name as place_name,
    oil.name,
    IF(day.km != '', SUM(day.km), '0') as km_sum,
    IF(day.hour != '', SUM(day.hour), '0') as hour_sum,
    cmod_oil.km,
    cmod_oil.hour,
    machine_historics.id,
    machine_historics.date,
    machine_historics.hour_initial,
    cmod_oil.hour_warning,
    day.id as day_id
    ").joins("
    INNER JOIN
    	vehicles veh ON veh.id = machine_historics.vehicle_id
    INNER JOIN
      places pla ON pla.id = veh.place_id
    INNER JOIN
        carmodels cmod ON cmod.id = veh.carmodel_id
    INNER JOIN
        oils oil ON oil.id = machine_historics.oil_id
    INNER JOIN
        carmodel_oils cmod_oil ON cmod_oil.carmodel_id = cmod.id AND cmod_oil.oil_id = oil.id
    LEFT JOIN
        vehicle_dailies day ON day.vehicle_id = veh.id
    ").where("
      machine_historics.status = 'aberto'
    ").group("
    machine_historics.id, machine_historics.oil_id
    ").having("
    (
       	machine_historics.hour_initial + ((km_sum * cmod_oil.hour / cmod_oil.km + hour_sum) - machine_historics.hour_initial) + cmod_oil.hour_warning < machine_historics.hour_initial + cmod_oil.hour
	  )
	  OR
    (
	      cmod_oil.km is null
	    AND 
       	machine_historics.hour_initial + (hour_sum - machine_historics.hour_initial) + cmod_oil.hour_warning < machine_historics.hour_initial + cmod_oil.hour
	  )
    OR
      (day_id is null)
    ")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @machine_historics }
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
        LEFT JOIN machine_historics mh ON mh.vehicle_id = vehicles.id AND mh.oil_id = oils.id
      ").find(:all, :conditions => ["vehicles.id = '#{params[:id]}'   AND
          ( 
        	(
        	SELECT
        		mhis.status
        	FROM
        		machine_historics mhis
        	WHERE
        		mhis.vehicle_id = vehicles.id 
        	AND 
        		mhis.oil_id = oils.id
        	ORDER BY
        		mhis.status
        	LIMIT
        		0,1
        	) != 'aberto'
          OR
            mh.id is null
          )"], :group => "oils.id")
      render :partial => "oil", :oils => @oils
  end
  
  def exchange
    @machine_historic = MachineHistoric.find(params[:id])
    
    @machine_historic.date = Time.zone.now
    @machine_historic.status = "fechado"
    
    @machine_historic.save
    
    @machine_initial = VehicleDaily.select("
    SUM(vehicle_dailies.km) as km_sum,
    ifnull(SUM(vehicle_dailies.hour), 0) as hour_sum,
    cmod_oil.km,
    cmod_oil.hour
    ").joins("
    INNER JOIN
     vehicles veh ON veh.id = vehicle_dailies.vehicle_id
    INNER JOIN
     carmodels cmod ON cmod.id = veh.carmodel_id 
    INNER JOIN
     machine_historics mhis ON mhis.vehicle_id = veh.id 
    INNER JOIN
     oils oil ON oil.id = mhis.oil_id
    INNER JOIN
     carmodel_oils cmod_oil ON cmod_oil.carmodel_id = cmod.id AND cmod_oil.oil_id = oil.id
    ").where("
      vehicle_dailies.vehicle_id = '#{@machine_historic.vehicle_id}'
    ").group("
      mhis.id, mhis.oil_id
    ").find(:first)
    
    @new_machine_historic = MachineHistoric.new
    @new_machine_historic.vehicle_id = @machine_historic.vehicle_id
    @new_machine_historic.oil_id = @machine_historic.oil_id
    @new_machine_historic.status = "aberto"
    
    if @machine_initial.km.blank?
        @new_machine_historic.hour_initial = @machine_initial.hour_sum
    else
        @machine_item = CarmodelOil.find(:first, :conditions => ["carmodel_id = '#{@machine_historic.vehicle.carmodel_id}'  AND oil_id = '#{@machine_historic.oil_id}'"])
        
        logger.debug "vale = #{@machine_initial.km_sum}"
        logger.debug "vale = #{@machine_initial.hour_sum}"
        logger.debug "vale = #{@machine_initial.km}"
        logger.debug "vale = #{@machine_initial.hour}"
        
        @new_machine_historic.hour_initial = @machine_initial.km_sum.to_f * @machine_item.hour.to_f / @machine_item.km.to_f + @machine_initial.hour_sum.to_f
    end
    
    @new_machine_historic.save
    
    redirect_to(machine_historics_url)
  end

  # GET /vehicle_historics/1
  # GET /vehicle_historics/1.xml
  def show
    @machine_historic = MachineHistoric.find(params[:id])
    
    @machine_oil = CarmodelOil.find(:first, :conditions => ["oil_id = ? AND carmodel_id = ?", @machine_historic.oil_id, @machine_historic.vehicle.carmodel_id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @machine_historic }
    end
  end

  # GET /vehicle_historics/new
  # GET /vehicle_historics/new.xml
  def new
    @machine_historic = MachineHistoric.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @machine_historic }
    end
  end

  # GET /vehicle_historics/1/edit
  def edit
    @machine_historic = MachineHistoric.find(params[:id])
  end

  # POST /vehicle_historics
  # POST /machine_historics.xml
  def create
    @machine_historic = MachineHistoric.new(params[:machine_historic])
    @machine_historic.status = "aberto"
    
    @machine_initial = VehicleDaily.select("
    SUM(vehicle_dailies.km) as km_sum,
    ifnull(SUM(vehicle_dailies.hour), 0) as hour_sum,
    cmod_oil.km,
    cmod_oil.hour
    ").joins("
    INNER JOIN
     vehicles veh ON veh.id = vehicle_dailies.vehicle_id
    INNER JOIN
     carmodels cmod ON cmod.id = veh.carmodel_id 
    INNER JOIN
     machine_historics mhis ON mhis.vehicle_id = veh.id 
    INNER JOIN
     oils oil ON oil.id = mhis.oil_id
    INNER JOIN
     carmodel_oils cmod_oil ON cmod_oil.carmodel_id = cmod.id AND cmod_oil.oil_id = oil.id
    ").where("
      vehicle_dailies.vehicle_id = '#{@machine_historic.vehicle_id}'
    ").group("
      mhis.id, mhis.oil_id
    ").find(:first)
    
    if @machine_initial.blank?
      @machine_historic.hour_initial = "0"
    elsif @machine_initial.km.blank?
        @machine_historic.hour_initial = @machine_initial.hour_sum
    else
        @machine_item = CarmodelOil.find(:first, :conditions => ["carmodel_id = '#{@machine_historic.vehicle.carmodel_id}'  AND oil_id = '#{@machine_historic.oil_id}'"])
        @machine_historic.hour_initial = @machine_initial.km_sum.to_f * @machine_item.hour.to_f / @machine_item.km.to_f + @machine_initial.hour_sum.to_f
    end
    
    respond_to do |format|
      if @machine_historic.save
        format.html { redirect_to(@machine_historic, :notice => 'Vehicle historic was successfully created.') }
        format.xml  { render :xml => @machine_historic, :status => :created, :location => @machine_historic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @machine_historic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vehicle_historics/1
  # PUT /vehicle_historics/1.xml
  def update
    @machine_historic = MachineHistoric.find(params[:id])
    @machine_historic.status = "aberto"

    respond_to do |format|
      if @machine_historic.update_attributes(params[:machine_historic])
        format.html { redirect_to(@machine_historic, :notice => 'Vehicle historic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @machine_historic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /machine_historics/1
  # DELETE /machine_historics/1.xml
  def destroy
    @machine_historic = MachineHistoric.find(params[:id])
    @machine_historic.destroy

    respond_to do |format|
      format.html { redirect_to(machine_historics_url) }
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
        LEFT JOIN machine_historics mh ON mh.vehicle_id = vehicles.id AND mh.oil_id = oils.id
      ").find(:all, :conditions => [" 
          carmodels.carmodel_type = 'Maquina'
          AND
        	(
        	  (
          	SELECT
          		mhis.status
          	FROM
          		machine_historics mhis
          	WHERE
          		mhis.vehicle_id = vehicles.id 
          	AND 
          		mhis.oil_id = oils.id
          	ORDER BY
          		mhis.status
          	LIMIT
          		0,1
          	) != 'aberto'
            OR
              mh.id is null
          )"], :group => "vehicles.id").collect { |c| [c.license_plate, c.id] }
    end
    
    def load_oils
      @oils = Array.new
    end
end