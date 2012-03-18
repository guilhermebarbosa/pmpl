class VehiclesController < ApplicationController
  before_filter [:load_brands], :only=>[:new,:edit, :create, :update]
  before_filter [:load_places], :only=>[:new,:edit, :create, :update]
  before_filter [:load_carmodels], :only=>[:new,:edit, :create, :update]

  
  def import  
    if notice.blank?
      @notice = ""
    else  
      @notice = notice
    end

    respond_to do |format|
      format.html
    end
  end
  
  def upload
    #file = DataFile.save(params[:upload][:csv])
    
    @file = params[:upload][:csv].read
    @x = 0
    
    FasterCSV.parse(@file).each do |row|
      @row = row
      if @x == 0
        @validate_header = validate_file_header()
        if @validate_header == false
          break;
        end
      else
        @validate_content = validate_file_h()
        if @validate_header == false
          break;
        end
      end
      @x = @x + 1
    end
    
    FasterCSV.parse(@file).each do |row|
      @row = row
      if @x == 0
        @validate_header = validate_file_header()
        if @validate_header == false
          break;
        end
      else
        @validate_header = validate_file_header()
        if @validate_header == false
          break;
        else
          
        end
        
        vehicle = Vehicle.find(:first, :conditions => ["brand_id = ?", @row[0]])
        
        @vehicle = Vehicle.new
        @vehicle.brand_id = brand.id
        @vehicle.name = row[0]
        @vehicle.save
      end
      @x = @x + 1
    end
    
    respond_to do |format|
      if @validate == false
        format.html { redirect_to(vehicles_import_path, :notice => 'Encontramos erro(s) na planilha, utilize como modelo a planilha encontrada nessa pagina.') }
      else
        format.html { redirect_to(vehicles_path, :notice => 'Carmodel was successfully created.') }
      end
    end 
  end
  
  # GET /vehicles
  # GET /vehicles.xml
  def index
    @vehicles = Vehicle.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vehicles }
    end
  end

  def update_carmodels_select
      @carmodels = Carmodel.where(:brand_id=>params[:id]).order(:name)
      render :partial => "carmodel", :carmodels => @carmodels
  end

  # GET /vehicles/1
  # GET /vehicles/1.xml
  def show
    @vehicle = Vehicle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vehicle }
    end
  end

  # GET /vehicles/new
  # GET /vehicles/new.xml
  def new
    @vehicle = Vehicle.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vehicle }
    end
  end

  # GET /vehicles/1/edit
  def edit
    @vehicle = Vehicle.find(params[:id])
  end

  # POST /vehicles
  # POST /vehicles.xml
  def create
    @vehicle = Vehicle.new(params[:vehicle])

    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to(@vehicle, :notice => 'Vehicle was successfully created.') }
        format.xml  { render :xml => @vehicle, :status => :created, :location => @vehicle }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vehicle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vehicles/1
  # PUT /vehicles/1.xml
  def update
    @vehicle = Vehicle.find(params[:id])

    respond_to do |format|
      if @vehicle.update_attributes(params[:vehicle])
        format.html { redirect_to(@vehicle, :notice => 'Vehicle was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vehicle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1
  # DELETE /vehicles/1.xml
  def destroy
    @vehicle = Vehicle.find(params[:id])
    @vehicle.destroy

    respond_to do |format|
      format.html { redirect_to(vehicles_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    def load_brands
      @brands = Brand.all.collect { |c| [c.name, c.id] }
    end
    def load_places
      @places = Place.all.collect { |c| [c.name, c.id] }
    end
    def load_carmodels
      if !params[:id].blank?
        vehicle = Vehicle.find(:first, params[:id])
        @carmodels = Carmodel.find(:all,vehicle.carmodel_id).collect { |c| [c.name, c.id] }
      else
        @carmodels = Array.new
      end
    end
    def validate_file_header
      if @row[0] != "Marca"
        return false
      end
      if @row[1] != "Modelo"
        return false
      end
      if @row[2] != "Modelo"
        return false
      end
      if @row[3] != "Placa"
        return false
      end
      if @row[4] != "Ano"
        return false
      end
    end
    def validate_file_content
      brand = Brand.find(:first, :conditions => ["name = ?", @row[0]])
      carmodel = Carmodel.find(:first, :conditions => ["name = ?", @row[1]])
      place = Place.find(:first, :conditions => ["name = ?", @row[2]])
      
      if brand.blank?
        return false
      end
      if carmodel.blank?
        return false
      end
      if place.blank?
        return false
      end
      if @row[3].blank?
        return false
      end
      if @row[4].blank?
        return false
      end
    end
end