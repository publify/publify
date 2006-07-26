require 'active_record'

class RailsInstaller
  
  # Parent class for database plugins for the installer.  To create a new 
  # webserver handler, subclass this class and define a 'start' and 'stop'
  # class method.
  class Database
    @@db_map = {}
    
    def self.backup(installer)
      raise "Not Implemented"
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
      ActiveRecord::Base.establish_connection(YAML.load(yml(installer))['production'])
      begin
        tables = ActiveRecord::Base.connection.tables
        if tables.size > 0
          installer.message "Database exists, preparing for upgrade"
          return
        end
      rescue
        # okay
      end
      
      installer.message "Creating initial database"
      
      schema_file = File.join(installer.install_directory,'db',"schema.#{installer.config['database']}.sql")
      schema = File.read(schema_file)
      
      # Remove comments and extra blank lines
      schema = schema.split(/\n/).map{|l| l.gsub(/^--.*/,'')}.select{|l| !(l=~/^$/)}.join("\n")
      
      schema.split(/;\n/).each do |command|
        ActiveRecord::Base.connection.execute(command)
      end
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

      def self.backup(installer)
        return unless File.exists? db_file(installer)

        new_db_file = db_file(installer)+"-#{Time.now.strftime('%Y%m%d-%H%M')}.sql"

        installer.message "Backing up existing SQLite database into #{new_db_file}"
        system("sqlite3 #{db_file(installer)} .dump > #{new_db_file}")
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
  end
end
