require 'active_record'

class RailsInstaller
  
  # Parent class for database plugins for the installer.  To create a new 
  # webserver handler, subclass this class and define a 'start' and 'stop'
  # class method.
  class Database
    @@db_map = {}

    def self.connect(installer)
      ActiveRecord::Base.establish_connection(YAML.load(yml(installer))['production'])
      begin
        tables = ActiveRecord::Base.connection.tables
        if tables.size > 0
          return true
        end
      rescue
        # okay
      end
      return false
    end
    
    def self.backup(installer)
      STDERR.puts "** backup **"
      return unless connect(installer)
      
      interesting_tables = ActiveRecord::Base.connection.tables.sort - ['sessions']
      backup_dir = File.join(installer.install_directory, 'db', 'backup')
      FileUtils.mkdir_p backup_dir
      backup_file = File.join(backup_dir, "backup-#{Time.now.strftime('%Y%m%d-%H%M')}.yml")

      installer.message "Backing up to #{backup_file}"
      
      data = {}
      interesting_tables.each do |tbl|
        data[tbl] = ActiveRecord::Base.connection.select_all("select * from #{tbl}")
      end

      File.open(backup_file,'w') do |file|
        YAML.dump data, file
      end
    end
    
    def self.restore(installer, filename)
      connect(installer)
      data = YAML.load(File.read(filename))
      
      installer.message "Restoring data"
      data.each_key do |table|
        if table == 'schema_info'
          ActiveRecord::Base.connection.execute("delete from schema_info")
          ActiveRecord::Base.connection.execute("insert into schema_info (version) values (#{data[table].first['version']})")
        else
          installer.message " Restoring table #{table} (#{data[table].size})"

          # Create a temporary model to talk to the DB
          eval %Q{
          class TempClass < ActiveRecord::Base
            set_table_name '#{table}'
            reset_column_information
          end
          }
          
          TempClass.delete_all
                
          data[table].each do |record|
            r = TempClass.new(record)
            r.save
          end
          
          if ActiveRecord::Base.connection.respond_to?(:reset_pk_sequence!)
            ActiveRecord::Base.connection.reset_pk_sequence!(table)
          end
        end
      end
    end
  
    def self.database_yml(installer)
      yml_file = File.join(installer.install_directory,'config','database.yml')
      return if File.exists? yml_file
      
      File.open(yml_file,'w') do |f|
        f.write(yml(installer))
      end
    end
    
    def self.create(installer)
      installer.message "Checking database"
      if connect(installer)
        installer.message "Database exists, preparing for upgrade"
        return
      end

      installer.message "Creating initial database"
      
      create_database(installer)
      
      schema_file = File.join(installer.install_directory,'db',"schema.#{installer.config['database']}.sql")
      schema = File.read(schema_file)
      
      # Remove comments and extra blank lines
      schema = schema.split(/\n/).map{|l| l.gsub(/^--.*/,'')}.select{|l| !(l=~/^$/)}.join("\n")
      
      schema.split(/;\n/).each do |command|
        ActiveRecord::Base.connection.execute(command)
      end
    end
    
    def self.create_database(installer)
      # nothing
    end

    def self.inherited(sub)
      name = sub.to_s.gsub(/^.*::/,'').gsub(/([A-Z])/) do |match|
        "_#{match.downcase}"
      end.gsub(/^_/,'')

      @@db_map[name] = sub
    end
    
    def self.dbs
      @@db_map
    end
  
    class Sqlite < RailsInstaller::Database
      # The name of the sqlite database file
      def self.db_file(installer)
        File.join(installer.install_directory,'db','database.sqlite')
      end
      
      def self.yml(installer)
        %q{
        login: &login
          adapter: sqlite3
          database: db/database.sqlite

        development:
          <<: *login

        production:
          <<: *login

        test:
          database: ":memory:"
          <<: *login
        }        
      end
    end
    
    class Postgresql < RailsInstaller::Database
      def self.yml(installer)
        %Q{
        login: &login
          adapter: postgresql
          host: #{installer.config['db_host'] || 'localhost'}
          username: #{installer.config['db_user'] || ENV['USER'] || 'typo' }
          password: #{installer.config['db_password']}
          database: #{installer.config['db_name'] || 'typo'}

        development:
          <<: *login

        production:
          <<: *login

        test:
          database: #{installer.config['db_name'] || 'typo'}-test
          <<: *login
        }        
      end
      
      def self.create_database(installer)
        installer.message "Creating PostgreSQL database"
        system("createdb -U #{installer.config['db_user'] || ENV['USER'] || 'typo'} #{installer.config['db_name'] || 'typo'}")
        system("createdb -U #{installer.config['db_user'] || ENV['USER'] || 'typo'} #{installer.config['db_name'] || 'typo'}-test")
      end
    end
  end
end
