class CreateRegistros < ActiveRecord::Migration
  def self.up
    create_table :registros do |t|
      t.references :usuario
      t.string :tipo, :limit => 2 # Indica entrada o salida E o S

      t.timestamps
    end
  end

  def self.down
    drop_table :registros
  end
end
