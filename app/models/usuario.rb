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

private
  def limpiar_espacios_blancos
    [:nombre, :paterno, :materno, :ci].each{|v| self.send(v).squish!}
  end
end
