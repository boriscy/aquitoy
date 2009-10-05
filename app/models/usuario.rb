class Usuario < ActiveRecord::Base
  has_many :registros


  def nombre_completo
    "#{self.nombre} #{self.paterno} #{self.materno}"
  end
end
