class RailsInstaller
  
  # Parent class for webserver plugins for the installer.  To create a new 
  # webserver handler, subclass this class and define a 'start' and 'stop'
  # class method.
  class WebServer
    @@server_map = {}
    
    def self.start(installer, foreground)
      raise "Not Implemented"
    end
  
    def self.stop(installer, foreground)
      raise "Not Implemented"
    end

    def self.inherited(sub)
      name = sub.to_s.gsub(/^.*::/,'').gsub(/([A-Z])/) do |match|
        "_#{match.downcase}"
      end.gsub(/^_/,'')

      @@server_map[name] = sub
    end
    
    def self.servers
      @@server_map
    end

    class Mongrel < RailsInstaller::WebServer
      def self.start(installer, foreground)
        args = {}
        args['-p'] = installer.config['port-number']
        args['-a'] = installer.config['bind-address']
        args['-e'] = installer.config['rails-environment']
        args['-d'] = foreground
        args['-P'] = pid_file(installer)
        args['--prefix'] = installer.config['url-prefix']

        # Remove keys with nil values
        args.delete_if {|k,v| v==nil}

        args_array = args.to_a.flatten.map {|e| e.to_s}
        args_array = ['mongrel_rails', 'start', installer.install_directory] + args_array
        installer.message "Starting #{installer.app_name.capitalize} on port #{installer.config['port-number']}"
        in_directory installer.install_directory do
          system(args_array.join(' '))
        end
      end
  
      def self.stop(installer)
        args = {}
        args['-P'] = pid_file(installer)

        args_array = args.to_a.flatten.map {|e| e.to_s}
        args_array = ['mongrel_rails', 'stop', installer.install_directory] + args_array
        installer.message "Stopping #{installer.app_name.capitalize}"
        in_directory installer.install_directory do
          system(args_array.join(' '))
        end
        
      end
      
      def self.pid_file(installer)
        File.join(installer.install_directory,'tmp','pid.txt')
      end
    end
    
    class MongrelCluster < RailsInstaller::WebServer
      def self.start(installer, foreground)
        args = {}
        args['-p'] = installer.config['port-number']
        args['-a'] = installer.config['bind-address']
        args['-e'] = installer.config['rails-environment']
        args['-N'] = installer.config['threads']
        args['--prefix'] = installer.config['url-prefix']

        # Remove keys with nil values
        args.delete_if {|k,v| v==nil}

        args_array = args.to_a.flatten.map {|e| e.to_s}
        args_array = ['mongrel_rails', 'cluster::configure'] + args_array
        installer.message "Configuring mongrel_cluster for #{installer.app_name.capitalize}"
        in_directory installer.install_directory do
          system(args_array.join(' '))
        end
        installer.message "Starting #{installer.app_name.capitalize} on port #{installer.config['port-number']}"
        in_directory installer.install_directory do
          system('mongrel_rails cluster::start')
        end
        
      end
  
      def self.stop(installer)
        installer.message "Stopping #{installer.app_name.capitalize}"
        in_directory installer.install_directory do
          system('mongrel_rails cluster::stop')
        end
      end
    end

    # Do-nothing webserver class.  Used when the installer doesn't control the web server.
    class External < RailsInstaller::WebServer
      def self.start(installer, foreground)
      end
      
      def self.stop(installer)
      end
    end
  end
end
