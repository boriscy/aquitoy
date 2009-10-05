class Usuario < ActiveRecord::Base
  has_many :registros

  has_attached_file :foto, :styles => {:mini => "90x90>"}

  def nombre_completo
    "#{self.nombre} #{self.paterno} #{self.materno}"
  end
end
