class AddUsuariosTelefono < ActiveRecord::Migration
  def self.up
    add_column :usuarios, :telefono, :string, :limit => 20
  end

  def self.down
    remove_column :usuarios, :telefono
  end
end
