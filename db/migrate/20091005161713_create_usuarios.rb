class CreateUsuarios < ActiveRecord::Migration
  def self.up
    create_table :usuarios do |t|
      t.string :nombre
      t.string :paterno
      t.string :materno
      t.string :ci
      t.boolean :activo

      t.timestamps
    end

    add_index :usuarios, :ci, :unique => true
  end

  def self.down
    drop_table :usuarios
  end
end
