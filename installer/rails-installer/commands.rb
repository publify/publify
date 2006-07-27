class RailsInstaller
  
  # Parent class for webserver plugins for the installer.  To create a new 
  # webserver handler, subclass this class and define a 'start' and 'stop'
  # class method.
  class Command
    @@command_map = {}
    
    def self.command(installer, *args)
      raise "Not Implemented"
    end
    
    def self.flag_help(text)
      @flag_help = text
    end
    
    def self.flag_help_text
      @flag_help || ''
    end
    
    def self.help(text)
      @help = text
    end
    
    def self.help_text
      @help || ''
    end
  
    def self.inherited(sub)
      name = sub.to_s.gsub(/^.*::/,'').gsub(/([A-Z])/) do |match|
        "_#{match.downcase}"
      end.gsub(/^_/,'')

      @@command_map[name] = sub
    end
    
    def self.commands
      @@command_map
    end
    
    class Install < RailsInstaller::Command
      help "Install or upgrade APPNAME in PATH."

      def self.command(installer, *args)
        version = nil
        args.each do |arg|
          if(arg =~ /^([^=]+)=(.*)$/)
            installer.config[$1.to_s] = $2.to_s
          else
            version = arg
          end
        end
        
        installer.install(version)
      end
    end
    
    class Config < RailsInstaller::Command
      help "Read or set a configuration variable"
      flag_help '[KEY=VALUE]...'

      def self.command(installer, *args)
        if args.size == 0
          installer.config.keys.sort.each do |k|
            puts "#{k}=#{installer.config[k]}"
          end
        else
          args.each do |arg|
            if(arg=~/^([^=]+)=(.*)$/)
              if $2.to_s.empty?
                installer.config.delete($1.to_s)
              else
                installer.config[$1.to_s]=$2.to_s
              end
            else
              puts installer.config[arg]
            end
          end
          installer.save
        end
      end
    end
    
    class Start < RailsInstaller::Command
      help "Start the web server in the background"

      def self.command(installer, *args)
        installer.start
      end
    end

    class Run < RailsInstaller::Command
      help "Start the web server in the foreground"
      
      def self.command(installer, *args)
        installer.start(true)
      end
    end

    class Restart < RailsInstaller::Command
      help "Stop and restart the web server."
      
      def self.command(installer, *args)
        installer.stop
        installer.start
      end
    end
    
    class Stop < RailsInstaller::Command
      help "Stop the web server"
      
      def self.command(installer, *args)
        installer.stop
      end
    end
    
    class Backup < RailsInstaller::Command
      help "Back up the database"
      
      def self.command(installer, *args)
        installer.backup_database
      end
    end
    
    class Restore < RailsInstaller::Command
      help "Restore a database backup"
      flag_help 'BACKUP_FILENAME'
      
      def self.command(installer, *args)
        installer.restore_database(args.first)
      end
    end
  end
end
  
