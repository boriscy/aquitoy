require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Registro do
  before(:each) do
    @valid_attributes = {
      :usuario_id => 1
    }

    @rangos = [["8:00", "9:00"], ["14:00", "15:00"]]
    Registro.definir_horarios(@rangos)
    Usuario.stub!(:find).and_return(mock_usuario)
  end

  def mock_usuario(stubs={})
    @mock_usuario ||= mock_model(Usuario, stubs)
  end

  def stub_horas(hora)
    d = Date.today
    t = Time.zone.parse("#{d} #{hora}")
    Time.zone.stub!(:now).and_return(t)
    Time.stub(:now).and_return(t)
  end


  it "debe crear un rango horas de entrada" do
    d = Date.today
    Registro.entradas[0].should == (Time.zone.parse("#{d} #{@rangos[0][0]}" )..Time.zone.parse("#{d} #{@rangos[0][1]}" ))
    Registro.entradas[1].should == (Time.zone.parse("#{d} #{@rangos[1][0]}" )..Time.zone.parse("#{d} #{@rangos[1][1]}" ))
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
    reg.tipo_print.should == "Entrada"
  end

  it "debe registrar hora de salida" do
    stub_horas("12:55")
    reg = Registro.create(:usuario_id => 1)
    reg.tipo.should == "S"
    reg.tipo_print.should == "Salida"
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

  it "debe cambiar entre días los rangos" do
    d = Date.today + 1.day
    Date.stub(:today).and_return(d)
    stub_horas("08:49")
    Registro.rangos_por_defecto = @rangos
    Registro.create(:usuario_id => 2)

    Registro.entradas[0].should == (Time.zone.parse("#{d} #{@rangos[0][0]}" )..Time.zone.parse("#{d} #{@rangos[0][1]}" ))
    Registro.entradas[1].should == (Time.zone.parse("#{d} #{@rangos[1][0]}" )..Time.zone.parse("#{d} #{@rangos[1][1]}" ))

  end

  it "debe buscar un usuario entre fechas" do
    @usuario_mock = mock_model(Usuario, :id => 1)

    stub_horas("08:40")
    Registro.create(:usuario_id => 1)
    stub_horas("12:30")
    Registro.create(:usuario_id => 1)
    stub_horas("14:40")
    Registro.create(:usuario_id => 1)
    # otro dia

    Registro.find_usuario_entre_fechas(1).size.should == 3
    d = Date.today
    Registro.find_usuario_entre_fechas(@usuario_mock, :fecha_inicial => d.to_s, :fecha_final => d).size.should == 3

  end

end
