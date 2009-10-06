require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Registro do
  before(:each) do
    @valid_attributes = {
      :usuario_id_id => 1
    }
    @rangos = [["8:00", "9:00"], ["14:00", "15:00"]]
    Registro.definir_horarios(@rangos)
  end

  def stub_horas(hora)
    d = Date.today
    t = Time.zone.parse("#{d} #{hora}")
    Time.zone.stub!(:now).and_return(t)
    Time.stub(:now).and_return(t)
  end

  it "should create a new instance given valid attributes" do
    #Registro.create!(@valid_attributes)
  end

  it "debe crear un rango horas de entrada" do
    Registro.entradas[0].should == (Time.zone.parse("#{Date.today} #{@rangos[0][0]}" )..Time.zone.parse("#{Date.today} #{@rangos[0][1]}" ))
    Registro.entradas[1].should == (Time.zone.parse("#{Date.today} #{@rangos[1][0]}" )..Time.zone.parse("#{Date.today} #{@rangos[1][1]}" ))
  end

  it "debe crear un rango horas de salida" do
    d = Date.today
    e = @rangos.inject([]){|arr, v| arr << (Time.zone.parse("#{d} #{v[1]}") )}
    e[0] = e[0] + 1
    e[1] = e[1] + 1
    s = []
    s[0] = Time.zone.parse("#{d} #{@rangos[1][0]}") - 1
    s[1] = Time.zone.parse("#{d} #{@rangos[0][0]}") + 1.day - 1
    Registro.salidas[0].should == (e[0]..s[0])
    Registro.salidas[1].should == (e[1]..s[1])
  end

  it "debe registrar hora de entrada" do
    stub_horas("8:55")
    reg = Registro.create!(:usuario_id => 1)
    reg.tipo.should == "E"
  end

  it "debe registrar hora de salida" do
    stub_horas("12:55")
    reg = Registro.create(:usuario_id => 1)
    reg.tipo.should == "S"
  end

  it "no debe registrar dos entradas para el mismo usuario" do
    stub_horas("08:40")

    Registro.definir_horarios()
    registro = Registro.create!(:usuario_id => 1)

    stub_horas("08:45")

    registro = Registro.create(:usuario_id => 1)
    registro.errors[:base].should_not == nil
  end

  it "no debe registrar dos salidas para el mismo usuario" do
    stub_horas("12:30")

    Registro.definir_horarios()
    registro = Registro.create!(:usuario_id => 1)

    stub_horas("12:45")

    registro = Registro.create(:usuario_id => 1)
    registro.errors[:base].should_not == nil
    registro.id.should == nil
  end

  it "registrar dos usuarios distintos entradas" do
    stub_horas("8:45")
    Registro.create!(:usuario_id => 1)

    stub_horas("8:46")
    registro = Registro.create(:usuario_id => 1)
    registro.errors[:base].should_not == nil
    registro.id.should == nil
  end


end
