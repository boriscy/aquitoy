class AddUsuarioFechaInicio < ActiveRecord::Migration
  def self.up
    add_column :usuarios, :fecha_ingreso, :date
  end

  def self.down
    remove_column :usuarios, :fecha_ingreso
  end
end
