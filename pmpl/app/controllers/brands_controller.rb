class BrandsController < ApplicationController
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
      if @x == 0
        @row = row
        @validate = validate_file()
        if @validate == false
          break;
        end
      else
        @brand = Brand.new
        @brand.name = row[0]
        @brand.save
      end
      @x = @x + 1
    end
    
    respond_to do |format|
      if @validate == false
        format.html { redirect_to(brands_import_path, :notice => 'Encontramos erro(s) na planilha, utilize como modelo a planilha encontrada nessa pagina.') }
      else
        format.html { redirect_to(brands_path, :notice => 'Carmodel was successfully created.') }
      end
    end 
  end
  
  def index
    @brands = Brand.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @brands }
    end
  end

  # GET /brands/1
  # GET /brands/1.xml
  def show
    @brand = Brand.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @brand }
    end
  end

  # GET /brands/new
  # GET /brands/new.xml
  def new
    @brand = Brand.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @brand }
    end
  end

  # GET /brands/1/edit
  def edit
    @brand = Brand.find(params[:id])
  end

  # POST /brands
  # POST /brands.xml
  def create
    @brand = Brand.new(params[:brand])

    respond_to do |format|
      if @brand.save
        format.html { redirect_to(@brand, :notice => 'Brand was successfully created.') }
        format.xml  { render :xml => @brand, :status => :created, :location => @brand }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @brand.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /brands/1
  # PUT /brands/1.xml
  def update
    @brand = Brand.find(params[:id])

    respond_to do |format|
      if @brand.update_attributes(params[:brand])
        format.html { redirect_to(@brand, :notice => 'Brand was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @brand.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /brands/1
  # DELETE /brands/1.xml
  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy

    respond_to do |format|
      format.html { redirect_to(brands_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    def validate_file
      if @row[0] != "Nome"
        return false
      end
    end
end