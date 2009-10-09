class Registro < ActiveRecord::Base
  
  # callbacks
  before_create :adicionar_entrada_salida

  cattr_reader :entradas, :salidas, :dia
  cattr_accessor :rangos_por_defecto
  
  # Asociaciones
  belongs_to :usuario

  # Validaciones
  validates_presence_of :usuario

  attr_accessor :ci

  def adicionar_entrada_salida
    salida = true
    ejecutado = false
    if @@dia.nil? or Date.today != @@dia
      self.class.flush_cache(:definir_horarios)
      self.class.definir_horarios(nil, Date.today.to_s)
    end

    @@entradas.each do |rango|
      if rango.include?(Time.zone.now)
        ejecutado = registrar_entrada(rango)
        salida = false
      end
    end

    if salida
      @@salidas.each do |rango|
        ejecutado = registrar_salida(rango) if rango.include?(Time.zone.now)
      end
    end

    # Retorna si se ejecuto correctament
    return ejecutado

  end

  # Formato de presentación para tipo
  def tipo_print
    case self.tipo
      when "E" then "Entrada"
      when "S" then "Salida"
    end
  end


#########################
# Metodos Privados
private

  # Regsitra la entrada entre el rango de horas que se le pasa ademas de
  # validar de que no haya duplicados
  # ==== Ejemplo
  #   registrar_entrada(Time.now..(Time.now + 1.hour))
  def registrar_entrada(rango)
    reg = self.class.last(:conditions => {:usuario_id => self.usuario_id})
    reg = self.class.new if reg.nil?
    unless rango.include?(reg.created_at)
      self.tipo = "E"
    else
      errors.add_to_base("Usted ya ha registrado su Entrada")
      return false
    end
 end


  def registrar_salida(rango)
    reg = self.class.last(:conditions => {:usuario_id => self.usuario_id}) || self.class.new
    unless rango.include?(reg.created_at)
      self.tipo = "S"
    else
      errors.add_to_base("Usted ya ha registrado su Salida")
      return false
    end
  end

###############################3
# Metodos isntanciados
  class << self
    extend ActiveSupport::Memoizable 

    def definir_horarios(arr = nil, dia = Date.today.to_s)
      crear_rangos_por_defecto() if @@rangos_por_defecto.nil? # Cuidado, hay que llamar la la funcion usando ()
      @@dia = Date.today
      arr ||= @@rangos_por_defecto
      @@entradas = crear_rangos_entradas(arr, dia)
      @@salidas = crear_rangos_salidas(arr, dia)
    end

    def crear_rangos_por_defecto
      @@rangos_por_defecto = [["08:20", "10:00"], ["14:00", "16:00"]]
    end
    
    # Memoriza el rango como un cache
    memoize :definir_horarios

    def entradas
      @@entradas
    end

    def salidas
      @@salidas
    end
    
    # Busqueda por usuario
    # @param (Object, Integer) usuario
    # @param String fecha_inicial
    # @param String fecha_final
    def find_usuario_entre_fechas(usuario, conditions = {})
      conditions[:fecha_inicial] ||= Time.zone.now.at_beginning_of_day
      conditions[:fecha_final] ||= conditions[:fecha_inicial]

      [:fecha_inicial, :fecha_final].each{|fecha|
        conditions[fecha] = convertir_fechahora(conditions[fecha]) if conditions[fecha].kind_of? Date or conditions[fecha].kind_of? String
      }
      conditions[:fecha_final] = (conditions[:fecha_final] + 1.day - 1.second)
      usuario = usuario.id if usuario.is_a? Usuario
      conditions[:created_at] = conditions[:fecha_inicial]..conditions[:fecha_final]
      conditions.delete(:fecha_inicial)
      conditions.delete(:fecha_final)
      conditions[:usuario_id] = usuario

      Registro.all(:conditions => conditions)
    end


  #####################################
  # Metodos privados
  private
    # Crear rangos validos para horas de entrada y salida
    # @param array horas
    # ==== Ejemplo:
    #   crear_rangos_entradas([["08:00", "09:00"],["14:00", "15:00"]], "2009-10-05")
    def crear_rangos_entradas(horas, dia)
      horas.inject([]){|arr, v|
        arr << ( Time.zone.parse("#{dia} #{v[0]}" )..Time.zone.parse("#{dia} #{v[1]}") )
        arr
      }
    end

    # Retorna un array con las horas de salida basado en las horas de entrada
    # @param array horas
    # ==== Ejemplo:
    #   crear_rangos_salidas([["08:00", "09:00"],["14:00", "15:00"]], "2009-10-05")
    def crear_rangos_salidas(horas, dia)
      ret = []
      ingreso_dia_siguiente = Time.zone.parse("#{dia} #{horas[0][0]}") + 1.day - 1.second

      horas.each_index do |i|
        hora_salida_inicial = Time.zone.parse("#{dia} #{horas[i][1]}") + 1
        if horas[i+1]
          hora_salida_final = Time.zone.parse("#{dia} #{horas[i+1][0]}") - 1
          ret << (hora_salida_inicial..hora_salida_final)
        else
          ret << (hora_salida_inicial..ingreso_dia_siguiente)
        end
      end
      ret
    end

    def convertir_fechahora(fecha)
      if fecha.kind_of? Date
        Time.zone.at(fecha.to_time)
      else
        Time.zone.parse(fecha)
      end
    end

  end


end
