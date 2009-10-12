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
    d = Date.parse("2009-10-01")
    Registro.definir_horarios(@rangos, d)
    ini = Time.zone.parse("2009-10-01 #{@rangos[0][1]}") + 1.second
    fin = Time.zone.parse("2009-10-01 #{@rangos[1][0]}") - 1.second
    Registro.salidas[0].should == (ini..fin)
    ini = Time.zone.parse("2009-10-01 #{@rangos[1][1]}") + 1.second
    fin = d.to_time + 1.day - 1.second
    Registro.salidas[1].should == (ini..fin)
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

  it "debe convertir horas a segundos" do
    Registro.convertir_hora_a_segundos("12:33").should == (12 * 60 ** 2 + 33 * 60)
    Registro.convertir_hora_a_segundos("18:33:15").should == (18 * 60 ** 2 + 33 * 60 + 15)
  end

  it "debe calcular las entradas en segundos crear_rangos_segundos()" do
    r1 = Registro.convertir_hora_a_segundos(@rangos[0][0])
    r2 = Registro.convertir_hora_a_segundos(@rangos[0][1])
    e = Registro.crear_rangos_segundos[:entradas]
    e[0].should == (r1..r2)
    r1 = Registro.convertir_hora_a_segundos(@rangos[1][0])
    r2 = Registro.convertir_hora_a_segundos(@rangos[1][1])
    e[1].should == (r1..r2)
  end

  it "debe calcular las salidas en segundos crear_rangos_segundos()" do
    r1, r2 = (Registro.convertir_hora_a_segundos(@rangos[0][1]) + 1), (Registro.convertir_hora_a_segundos(@rangos[1][0]) - 1)
    s = Registro.crear_rangos_segundos[:salidas]
    s[0].should == (r1..r2)
    r1, r2 = (Registro.convertir_hora_a_segundos(@rangos[1][1]) + 1), Registro.convertir_hora_a_segundos("23:59:59")
    s[1].should == (r1..r2)
  end

end
