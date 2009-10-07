require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Usuario do
  before(:each) do
    @valid_attributes = {
      :nombre => "Amaru",
      :paterno => "Barroso",
      :materno => "Luna Pizarro",
      :ci => "3354546"
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
      :ci => "3354546 "
    }
    @usuario = Usuario.create!(@usuario_attributes)
    
    [:nombre, :paterno, :materno, :ci].each{|v| 
      @usuario.send(v).should == @usuario_attributes[v].squish
    }

  end
  
end
