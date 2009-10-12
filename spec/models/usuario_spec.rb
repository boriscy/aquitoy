require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Usuario do
  before(:each) do
    @valid_attributes = {
      :nombre => "Amaru",
      :paterno => "Barroso",
      :materno => "Luna Pizarro",
      :ci => "3354546",
      :login => "kari",
      :password => "amaru123",
      :password_confirmation => "amaru123"
    }
    @usuario = Usuario.new(@valid_attributes)
  end

  it{ should validate_numericality_of(:ci) }
  it{ should validate_presence_of(:ci) }

  def crear_usuario
    @usuario = Usuario.create(@valid_attributes)
  end


  it "should create a new instance given valid attributes" do
    Usuario.create!(@valid_attributes)
  end

  it "tener nombre_completo" do
    @usuario = Usuario.create!(@valid_attributes)
    nombre_completo = [:nombre, :paterno, :materno].inject([]){|arr, v| arr << @valid_attributes[v] }.join(" ").squish
    @usuario.nombre_completo.should == nombre_completo
  end

  it "debe limpiar espacios blancos" do
    @usuario_attributes = {
      :nombre => "Amaru ",
      :paterno => "Barroso ",
      :materno => "Luna  Pizarro ",
      :ci => "3354546 ",
      :login => "kari",
      :password => "amaru123",
      :password_confirmation => "amaru123"
    }
    @usuario = Usuario.create!(@usuario_attributes)
    
    [:nombre, :paterno, :materno, :ci].each{|v| 
      @usuario.send(v).should == @usuario_attributes[v].squish
    }

  end

  it "debe retornar registros ordenados para un usuario" do
    mock_model(Registro)
    @usuario = Usuario.create(@valid_attributes)
    arr = []
    a = ["2009-10-10 8:30", "2009-10-10 12:55", "2009-10-10 14:00",
    "2009-10-11 8:30", "2009-10-11 12:55", "2009-10-11 14:00", "2009-10-11 18:50"]
    a.each_index do |i|
      r = Registro.new(:created_at => Time.parse(a[i]), :tipo => "S", :usuario_id => @usuario.id)
      r.tipo = "E" if i % 2 == 0
      arr << r
    end
    Registro.stub!(:find_usuario_entre_fechas).with(kind_of(Fixnum), kind_of(Hash)).and_return(arr)

#    @usuario.registros_ordenados[0][:entradas].size.should == 2 #[arr[0], arr[2]]
    @usuario.registros_ordenados[0][:salidas].should == [arr[1], Registro.new]

  end
  
end
