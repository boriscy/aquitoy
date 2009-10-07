class RegistrosController < ApplicationController
  # GET /registros
  # GET /registros.xml
  def index
    @registros = Registro.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @registros }
    end
  end

  # GET /registros/1
  # GET /registros/1.xml
  def show
    @registro = Registro.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @registro }
    end
  end

  # GET /registros/new
  # GET /registros/new.xml
  def new
    @registro = Registro.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @registro }
    end
  end

  # GET /registros/1/edit
  def edit
    @registro = Registro.find(params[:id])
  end

  # POST /registros
  # POST /registros.xml
  def create
    @usuario = Usuario.find_by_ci(params[:registro][:ci])
    if @usuario
      @registro = Registro.new(:usuario_id => @usuario.id)
    end

    respond_to do |format|
      if @registro and @registro.save
        flash[:notice] = "<span class=\"hora\">#{@registro.tipo == "E"? "Entrada" : "Salida"}</span>
          #{@usuario.nombre_completo} con ci: #{@usuario.ci} a horas 
          <span class=\"hora\">#{I18n.l(@registro.created_at, :format => "%H:%M")}</span>"

        @registro = Registro.new
        format.html { render :action => "new" }
        format.xml  { render :xml => @registro, :status => :created, :location => @registro }
      elsif @usuario
        format.html { render :action => "new" }
        format.xml  { render :xml => @registro.errors, :status => :unprocessable_entity }
      else
        @registro = Registro.new
        flash[:error] = "El usuario que ingreso no existe"
        format.html {render :action => "new"}
      end
    end
  end

  # PUT /registros/1
  # PUT /registros/1.xml
  def update
    @registro = Registro.find(params[:id])

    respond_to do |format|
      if @registro.update_attributes(params[:registro])
        flash[:notice] = 'Registro was successfully updated.'
        format.html { redirect_to(@registro) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @registro.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /registros/1
  # DELETE /registros/1.xml
  def destroy
    @registro = Registro.find(params[:id])
    @registro.destroy

    respond_to do |format|
      format.html { redirect_to(registros_url) }
      format.xml  { head :ok }
    end
  end
end
