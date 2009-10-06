class Registro < ActiveRecord::Base
  
  # callbacks
  before_create :adicionar_entrada_salida

  cattr_reader :entradas, :salidas
  
  belongs_to :usuario

  attr_accessor :ci


  # Adiciona las horas de entrada o salida
  def adicionar_entrada_salida
    salida = true
    ejecutado = false
    self.class.definir_horarios() if @@entradas.nil?

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

    def definir_horarios(arr = nil)
      arr ||= [["08:20", "10:00"], ["14:20", "16:00"]]
      @@entradas = crear_rangos_entradas(arr)
      @@salidas = crear_rangos_salidas(arr)
    end
    
    def entradas
      @@entradas
    end

    def salidas
      @@salidas
    end

    # Memoriza el rango como un cache
    memoize :definir_horarios

  #####################################
  # Metodos privados
  private
    # Crear rangos validos para horas de entrada y salida
    # @param array horas
    # ==== Ejemplo:
    #   crear_rangos_entradas([["08:00", "09:00"],["14:00", "15:00"]])
    def crear_rangos_entradas(horas)
      d = Date.today.to_s
      horas.inject([]){|arr, v|
        arr << ( Time.zone.parse("#{d} #{v[0]}" )..Time.zone.parse("#{d} #{v[1]}") )
        arr
      }
    end

    # Retorna un array con las horas de salida basado en las horas de entrada
    # @param array horas
    # ==== Ejemplo:
    #   crear_rangos_salidas([["08:00", "09:00"],["14:00", "15:00"]])
    def crear_rangos_salidas(horas)
      d = Date.today.to_s
      ret = []
      ingreso_dia_siguiente = Time.zone.parse("#{d} #{horas[0][0]}") + 1.day - 1.second

      horas.each_index do |i|
        hora_salida_inicial = Time.zone.parse("#{d} #{horas[i][1]}") + 1
        if horas[i+1]
          hora_salida_final = Time.zone.parse("#{d} #{horas[i+1][0]}") - 1
          ret << (hora_salida_inicial..hora_salida_final)
        else
          ret << (hora_salida_inicial..ingreso_dia_siguiente)
        end
      end
      ret
    end

  end


end
