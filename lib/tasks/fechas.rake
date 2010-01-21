require 'mocha'

namespace :usuario do
  namespace :registros do
    task :crear => :environment do
      path = File.join(RAILS_ROOT, "db/usuarios_nombres.yml")
      usuarios = YAML::parse(File.open(path)).transform
      Registro.stubs(:adicionar_entrada_salida)

      fecha_inicio = Date.parse("2009-08-01")
      fecha_fin = Date.parse("2010-01-20")
      horas_ingreso = ["09:00", "15:00"]
      horas_salida = ["13:00", "19:00"]

      usuarios.each do |v|
        u = Usuario.find_by_nombre_and_paterno(v[:nombre], v[:paterno])

        # Actualizar fecha de ingreso
        #puts "#{v[:nombre]} #{v[:paterno]} #{u.update_attributes(:fecha_ingreso => v[:fecha_ingreso])}"
        # Crear horarios
        dia = 0
        puts u.nombre_completo
        begin 
          fecha = v[:fecha_ingreso] + dia.days
          unless [0, 6].include?(fecha.wday)
            if v[:variacion]
              ingreso1 = Time.parse("#{fecha} #{horas_ingreso.first}") + rand(v[:variacion]).minutes
              ingreso2 = Time.parse("#{fecha} #{horas_ingreso.last}") + rand(v[:variacion]).minutes
            else
              ingreso1 = Time.parse("#{fecha} #{horas_ingreso.first}") + (rand(30) - 15).minutes
              ingreso2 = Time.parse("#{fecha} #{horas_ingreso.last}") + (rand(30) - 15).minutes
            end
            salida1 = Time.parse("#{fecha} #{horas_salida.first}") + rand(20).minutes
            salida2 = Time.parse("#{fecha} #{horas_salida.last}") + rand(180).minutes
            
            Registro.create({:usuario_id => u.id, :tipo => "E", :created_at => ingreso1})
            Registro.create({:usuario_id => u.id, :tipo => "S", :created_at => salida1})
            Registro.create({:usuario_id => u.id, :tipo => "E", :created_at => ingreso2})
            Registro.create({:usuario_id => u.id, :tipo => "S", :created_at => salida2})
            #puts "#{ingreso1} #{salida1} #{ingreso2} #{salida2}"

          end
          

          dia += 1
        end while fecha < fecha_fin

      end
      inicio = Date.parse("2009-08-01")
      fin = Date.parse("2010-01-15")
    end
  end
end
