class RailsInstaller
  
  # Parent class for webserver plugins for the installer.  To create a new 
  # webserver handler, subclass this class and define a 'start' and 'stop'
  # class method.
  class Command
    @@command_map = {}
    
    def self.command(installer, *args)
      raise "Not Implemented"
    end
    
    def self.help(installer)
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
      
      def self.help(installer)
        ['',"Install or upgrade #{installer.app_name} in PATH."]
      end
    end
    
    class Config < RailsInstaller::Command
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
      
      def self.help(installer)
        ['[KEY=VALUE]...',"Read or set a #{installer.app_name} configuration variable"]
      end
    end
    
    class Start < RailsInstaller::Command
      def self.command(installer, *args)
        installer.start
      end
      
      def self.help(installer)
        ['',"Start the web server for #{installer.app_name} in the background"]
      end
    end

    class Run < RailsInstaller::Command
      def self.command(installer, *args)
        installer.start(true)
      end
      
      def self.help(installer)
        ['',"Start the web server for #{installer.app_name} in the foreground"]
      end
    end

    class Restart < RailsInstaller::Command
      def self.command(installer, *args)
        installer.stop
        installer.start
      end
      
      def self.help(installer)
        ['',"Stop and restart the web server for #{installer.app_name}."]
      end
    end
    
    class Stop < RailsInstaller::Command
      def self.command(installer, *args)
        installer.stop
      end

      def self.help(installer)
        ['',"Stop the web server for #{installer.app_name}"]
      end
    end
  end
end
  
