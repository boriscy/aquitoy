class Usuario < ActiveRecord::Base

  # Callbacks
  before_save :limpiar_espacios_blancos
  before_validation :adicionar_login_password, :if => Proc.new{ |usuario| usuario.login.blank? and usuario.id.nil? }

  # Asociaciones
  has_many :registros


  # Behaviors
  has_attached_file :foto, :styles => {:mini => "90x90>", :medium => "200x200>"}
  acts_as_authentic do |config|
    config.login_field = :login
    config.merge_validates_format_of_login_field_options(:with => /\A^[-@_a-z0-9]+$\Z/i )
    config.merge_validates_length_of_login_field_options(:within => 4..20 )
  end


  # Validaciones
  validates_numericality_of :ci
  validates_presence_of :ci, :nombre, :paterno, :materno
  validates_format_of :telefono, :with => /\A^[1-9]+[-0-9]+[0-9]+$\Z/, 
    :unless => Proc.new{|usuario| usuario.telefono.blank? }, :message => "Debe ingresar solo números separado con guión"


  def nombre_completo
    "#{self.nombre} #{self.paterno} #{self.materno}"
  end

  # Presenta los registros de un usuario entre fechas
  # @params Hash conditions
  # @return Array # => Lista de objectos con los registros que esten en el rango de fechas y condiciones
  # ==== Ejemplo
  #   registro_fechas(:fecha_inicial => '2009-10-01', :fecha_final => Date.today)
  def registros_ordenados(conditions = {})
    Registro.find_usuario_entre_fechas(self.id, conditions).group_by{|f| f.created_at.to_date }
  end

private
  def limpiar_espacios_blancos
    [:nombre, :paterno, :materno, :ci].each{ |v| self.send(v).squish! }
  end

  def adicionar_login_password
    self.login = self.nombre.squish.gsub(/\s/, "-")
    self.password = "ajklshdfuhas76767H"
    self.password_confirmation = "ajklshdfuhas76767H"
  end

  ################################################
  class << self

  end

end
