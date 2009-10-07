class Usuario < ActiveRecord::Base

  # Callbacks
  before_save :limpiar_espacios_blancos

  has_many :registros

  has_attached_file :foto, :styles => {:mini => "90x90>", :medium => "200x200>"}

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
