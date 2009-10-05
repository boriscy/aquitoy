require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Registro do
  before(:each) do
    @valid_attributes = {
      :usuario_id_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    #Registro.create!(@valid_attributes)
  end

  it "debe crear un rango" do
    rangos = [["8:00", "9:00"], ["2:00", "6:00"]]
    resp = Registro.definir_horas_entrada(rangos)
    resp[0].first.should == Time.zone.parse("#{Date.today} #{rangos[0][0]}" )
    resp[0].last.should == Time.zone.parse("#{Date.today} #{rangos[0][1]}" )
    resp[1].first.should == Time.zone.parse("#{Date.today} #{rangos[1][0]}" )
    resp[1].last.should == Time.zone.parse("#{Date.today} #{rangos[1][1]}" )

  end

  it "debe crear un rango si no hay parametros" do
    rangos = [["08:20", "10:00"], ["14:20", "16:00"]]
    resp = Registro.definir_horas_entrada()
    resp[0].first.should == Time.zone.parse("#{Date.today} #{rangos[0][0]}" )
    resp[0].last.should == Time.zone.parse("#{Date.today} #{rangos[0][1]}" )
    resp[1].first.should == Time.zone.parse("#{Date.today} #{rangos[1][0]}" )
    resp[1].last.should == Time.zone.parse("#{Date.today} #{rangos[1][1]}" )
  end
  
  it "debe registrar en el rango de entrada" do
    t = Time.zone.parse("#{Date.today} 08:34")
    Time.zone.stub!(:now).and_return(t)
    Registro.definir_horas_entrada()
    registro = Registro.create(:usuario_id => 1)
    registro.tipo.should == "E"

    t = Time.zone.parse("#{Date.today} 15:59")
    Time.zone.stub!(:now).and_return(t)
    registro = Registro.create(:usuario_id => 1)
    registro.tipo.should == "E"
  end
 
  it "debe registrar en el rango de salida" do
    t = Time.zone.parse("#{Date.today} 12:34")
    Time.zone.stub!(:now).and_return(t)
    Registro.definir_horas_entrada()
    registro = Registro.create(:usuario_id => 1)
    registro.tipo.should == "S"

    t = Time.zone.parse("#{Date.today} 19:59")
    Time.zone.stub!(:now).and_return(t)
    registro = Registro.create(:usuario_id => 1)
    registro.tipo.should == "S"
  end

end

