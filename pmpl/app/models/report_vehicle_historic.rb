class ReportVehicleHistoric < ActiveRecord::Base

  def vehicle_historics
    @vehicle_historics ||= find_vehicle_historics
  end

  private

    def find_vehicle_historics
      @report_vehicle_historics = VehicleHistoric.select("
      veh.license_plate,
      pla.name as place_name,
      oil.name,
      SUM(day.km) as km_atual,
      cmod_oil.km,
      vehicle_historics.id,
      vehicle_historics.vehicle_id,
      vehicle_historics.date,
      vehicle_historics.km_initial,
      vehicle_historics.status
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
      ").find(:all, :conditions => conditions, :group => "
        vehicle_historics.id, 
        vehicle_historics.oil_id
      ", :order => "
        vehicle_historics.vehicle_id, 
        vehicle_historics.oil_id, 
        vehicle_historics.date DESC
      ")
    end

    def status_conditions
      ["vehicle_historics.status = ?", status] unless status.blank?
    end

    def initial_date_conditions
      ["vehicle_historics.date >= ?", initial_date] unless initial_date.blank?
    end

    def end_date_conditions
      ["vehicle_historics.date <= ?", end_date] unless end_date.blank?
    end
    
    def place_conditions
      ["pla.id = ?", place_id] unless place_id.blank?
    end
    
    def oil_conditions
      ["vehicle_historics.oil_id = ?", oil_id] unless oil_id.blank?
    end

    def vehicle_conditions
      ["vehicle_historics.vehicle_id = ?", vehicle_id] unless vehicle_id.blank?
    end

    def conditions
      [conditions_clauses.join(' AND '), *conditions_options]
    end

    def conditions_clauses
      conditions_parts.map { |condition| condition.first }
    end

    def conditions_options
      conditions_parts.map { |condition| condition[1..-1] }.flatten
    end

    def conditions_parts
      private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
    end

end