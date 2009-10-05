class Registro < ActiveRecord::Base
  
  # callbacks
  before_create :adicionar_entrada_salida

  @salidas = []
  
  belongs_to :usuario

  attr_accessor :ci

  def adicionar_entrada_salida
    self.tipo = "S"
    self.class.definir_horas_entrada().each do |v|
      reg = self.class.last(:conditions => {:created_at => v})
      reg = self.class.new if reg.nil?

      if v.include?(Time.zone.now) and !v.include?(reg.created_at)
        self.tipo = "E"
      else
        errors.add_to_base("Usted ya ha sido registrado")
        return false
      end
    end

  end


  class << self
    extend ActiveSupport::Memoizable 

    # Define los horarios de entrada
    # Puede pasarse parametros con los horarios de entrada
    # Inicialmente estan codificadas en la función
    # con la hora inicial hasta la hora final de entrada para poder
    # crear un rango
    def definir_horas_entrada(arr = nil)
      arr ||= [["08:20", "10:00"], ["14:20", "16:00"]]
      crear_rangos_entradas(arr)
    end
    # Memoriza el rango como un cache
    memoize :definir_horas_entrada

  private
    # Crear rangos validos para horas de entrada y salida
    # @param array horas
    def crear_rangos_entradas(horas)
      d = Date.today.to_s
      horas.inject([]){|arr, v|
        arr << ( Time.zone.parse("#{d} #{v[0]}" )..Time.zone.parse("#{d} #{v[1]}") )
        arr
      }
    end

  end


end
