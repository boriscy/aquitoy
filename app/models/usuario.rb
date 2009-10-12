class Usuario < ActiveRecord::Base

  # Callbacks
  before_save :limpiar_espacios_blancos

  # Asociaciones
  has_many :registros

  # Behaviors
  has_attached_file :foto, :styles => {:mini => "90x90>", :medium => "200x200>"}
  acts_as_authentic do |config|
    config.login_field = :login
    config.merge_validates_format_of_login_field_options(:with => /\A^[a-z_0-9@]+$\Z/i)
    config.merge_validates_length_of_login_field_options(:within => 4..20)
  end


  # Validaciones
  validates_numericality_of :ci
  validates_presence_of :ci, :nombre, :paterno, :materno


  def nombre_completo
    "#{self.nombre} #{self.paterno} #{self.materno}"
  end

  # Presenta los registros de un usuario entre fechas
  # @params Hash conditions
  # @return Array # => Lista de objectos con los registros que esten en el rango de fechas y condiciones
  # ==== Ejemplo
  #   registro_fechas(:fecha_inicial => '2009-10-01', :fecha_final => Date.today)
  def registros_ordenados(conditions = {})
    registros = Registro.find_usuario_entre_fechas(self.id, conditions).group_by{|f| f.created_at.to_date }
    ret = []
    rangos = Registro.crear_rangos_segundos()

    iteraciones = rangos[:entradas].size * 2
    registros.each do |fecha, regs|
      pos = 0
      hora = Registro.convertir_hora_a_segundos(reg.created_at.to_s.gsub(/^[0-9-]+ ([0-9:]+) [-0-9]+$/, '\1'))
      iteraciones.times |i|
        tipo = (i % 2 == 0) ? "E" : "S"
        if tipo == "E" and regs[pos]
          r = regs[i]
          pos += 1
        elsif tipo == "S" and regs[pos]
          r = tipo
          pos += 1
        else
          r = Registro.new
        end
        h[:entradas] << r
      end
      h = {:fecha => fecha, :entradas => [], :salidas => []}

      regs.each do |reg|
        hora = Registro.convertir_hora_a_segundos(reg.created_at.to_s.gsub(/^[0-9-]+ ([0-9:]+) [-0-9]+$/, '\1'))
        
        if reg.tipo == "E"
          rangos[:entradas].each_index do |i|
            h[:entradas] << Registro.new
            h[:entradas][h[:entradas].size - 1] = reg if reg and rangos[:entradas][i].include?(hora)
          end
        else
          rangos[:salidas].each_index do |i|
            h[:salidas] << Registro.new
            h[:salidas][h[:salidas].size - 1] = reg if reg and rangos[:salidas][i].include?(hora)
          end
        end
      end
 debugger 
      ret << h
    end

    ret
  end

private
  def limpiar_espacios_blancos
    [:nombre, :paterno, :materno, :ci].each{|v| self.send(v).squish!}
  end

  ################################################
  class << self

  end

end
