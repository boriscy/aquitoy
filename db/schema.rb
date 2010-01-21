# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100120215149) do

  create_table "registros", :force => true do |t|
    t.integer  "usuario_id"
    t.string   "tipo",       :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usuarios", :force => true do |t|
    t.string   "nombre"
    t.string   "paterno"
    t.string   "materno"
    t.string   "ci"
    t.boolean  "activo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "foto_file_name"
    t.integer  "foto_file_size"
    t.string   "login",             :limit => 20
    t.string   "password",          :limit => 40
    t.string   "password_salt"
    t.string   "crypted_password"
    t.string   "persistence_token"
    t.string   "telefono",          :limit => 20
    t.date     "fecha_ingreso"
  end

end
