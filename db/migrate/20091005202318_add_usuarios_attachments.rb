class AddUsuariosAttachments < ActiveRecord::Migration
  def self.up
    add_column :usuarios, :foto_file_name, :string
    add_column :usuarios, :foto_file_size, :integer
  end

  def self.down
    remove_column :usuarios, :foto_file_name
    remove_column :usuarios, :foto_file_size
  end
end
