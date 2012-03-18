class VehicleDailiesController < ApplicationController
  before_filter [:load_vehicles]
  
  # GET /vehicle_dailies
  # GET /vehicle_dailies.xml
  def index
    @vehicle_dailies = VehicleDaily.all.paginate(:per_page => 10, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vehicle_dailies }
    end
  end

  # GET /vehicle_dailies/1
  # GET /vehicle_dailies/1.xml
  def show
    @vehicle_daily = VehicleDaily.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vehicle_daily }
    end
  end

  # GET /vehicle_dailies/new
  # GET /vehicle_dailies/new.xml
  def new
    @vehicle_daily = VehicleDaily.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vehicle_daily }
    end
  end

  # GET /vehicle_dailies/1/edit
  def edit
    @vehicle_daily = VehicleDaily.find(params[:id])
  end

  # POST /vehicle_dailies
  # POST /vehicle_dailies.xml
  def create
    @vehicle_daily = VehicleDaily.new(params[:vehicle_daily])

    respond_to do |format|
      if @vehicle_daily.save
        
        check_email
        
        format.html { redirect_to(@vehicle_daily, :notice => 'Vehicle daily was successfully created.') }
        format.xml  { render :xml => @vehicle_daily, :status => :created, :location => @vehicle_daily }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vehicle_daily.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vehicle_dailies/1
  # PUT /vehicle_dailies/1.xml
  def update
    @vehicle_daily = VehicleDaily.find(params[:id])

    respond_to do |format|
      if @vehicle_daily.update_attributes(params[:vehicle_daily])
        
        check_email
        
        format.html { redirect_to(@vehicle_daily, :notice => 'Vehicle daily was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vehicle_daily.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicle_dailies/1
  # DELETE /vehicle_dailies/1.xml
  def destroy
    @vehicle_daily = VehicleDaily.find(params[:id])
    @vehicle_daily.destroy

    respond_to do |format|
      format.html { redirect_to(vehicle_dailies_url) }
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
        LEFT JOIN machine_historics mh ON mh.vehicle_id = vehicles.id AND mh.oil_id = oils.id
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
          	OR
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
          	) = 'aberto'
          )"], :group => "vehicles.id").collect { |c| [c.license_plate, c.id] }
    end
    
    def check_email
      
      @email_warning_vehicle = VehicleHistoric.select("
      veh.license_plate,
      pla.name as place_name,
      oil.name,
      SUM(day.km) as km_atual,
      cmod_oil.km,
      vehicle_historics.id,
      vehicle_historics.km_initial,
      vehicle_historics.date,
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
      AND
        vehicle_historics.vehicle_id = '#{@vehicle_daily.vehicle_id}'
      AND
        vehicle_historics.email = '0'
      ").group("
      vehicle_historics.id, vehicle_historics.oil_id
      ").having("
        vehicle_historics.km_initial + (km_atual - vehicle_historics.km_initial) < vehicle_historics.km_initial + cmod_oil.km 
      AND 
        vehicle_historics.km_initial + (km_atual - vehicle_historics.km_initial) + cmod_oil.km_warning >= vehicle_historics.km_initial + cmod_oil.km
      ")
      
      @email_warning_machine = MachineHistoric.select("
      veh.license_plate,
      pla.name as place_name,
      oil.name,
      SUM(day.km) as km_sum,
      SUM(day.hour) as hour_sum,
      cmod_oil.km,
      cmod_oil.hour,
      cmod_oil.hour_warning,
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
      AND
        machine_historics.vehicle_id = '#{@vehicle_daily.vehicle_id}'
      AND
        machine_historics.email = '0'
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
      
      if !@email_warning_vehicle[0].blank?
        @email_warning_vehicle.each do |warning|
          
          @oil_update = VehicleHistoric.find(warning.id)
          @oil_update.email = "1"
          @oil_update.save
          
          HistoricMailer.vehicle_historic_alert(warning).deliver
        end
      end
      
      logger.debug "vale = #{@email_warning_machine[0]}"
      
      if !@email_warning_machine[0].blank?
        @email_warning_machine.each do |warning|
          
          @oil_update = MachineHistoric.find(warning.id)
          @oil_update.email = "1"
          @oil_update.save
          
          HistoricMailer.machine_historic_alert(warning).deliver
        end
      end
    end
end