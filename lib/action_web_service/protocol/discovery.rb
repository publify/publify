module ActionWebService # :nodoc:
  module Protocol # :nodoc:
    module Discovery # :nodoc:
      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, ActionWebService::Protocol::Discovery::InstanceMethods)
        base.send(:class_attribute, :web_service_protocols)
        base.send(:web_service_protocols=, [])
      end

      module ClassMethods # :nodoc:
        def register_protocol(klass)
          self.web_service_protocols += [klass]
        end
      end

      module InstanceMethods # :nodoc:
        private
          def discover_web_service_request(action_pack_request)
            (self.class.web_service_protocols || []).each do |protocol|
              protocol = protocol.create(self)
              request = protocol.decode_action_pack_request(action_pack_request)
              return request unless request.nil?
            end
            nil
          end
      end
    end
  end
end
