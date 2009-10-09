class AddUsuarioLogin < ActiveRecord::Migration
  def self.up
    add_column :usuarios, :login, :string, :limit => 20
    add_column :usuarios, :password, :string,:limit => 40
    add_column :usuarios, :password_salt, :string
    add_column :usuarios, :crypted_password, :string
    add_column :usuarios, :persistence_token, :string
  end
  def self.down
    remove_column :usuarios, :login
    remove_column :usuarios, :password
    remove_column :usuarios, :password_salt
    remove_column :usuarios, :crypted_password
    remove_column :usuarios, :persistence_token
  end
end
