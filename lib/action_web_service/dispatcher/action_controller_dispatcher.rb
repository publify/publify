require 'benchmark'
require 'builder/xmlmarkup'

module ActionWebService # :nodoc:
  module Dispatcher # :nodoc:
    module ActionControllerX # :nodoc:
      def self.included(base) # :nodoc:
        base.class_eval do
          alias_method :web_service_direct_invoke_without_controller, :web_service_direct_invoke
        end
        base.add_web_service_api_callback do |klass, api|
          if klass.web_service_dispatching_mode == :direct
            klass.class_eval 'def api; dispatch_web_service_request; end'
          end
        end
        base.add_web_service_definition_callback do |klass, name, info|
          if klass.web_service_dispatching_mode == :delegated
            klass.class_eval "def #{name}; dispatch_web_service_request; end"
          elsif klass.web_service_dispatching_mode == :layered
            klass.class_eval 'def api; dispatch_web_service_request; end'
          end
        end
        base.send(:include, ActionWebService::Dispatcher::ActionControllerX::InstanceMethods)
      end

      module InstanceMethods # :nodoc:
        private
          def dispatch_web_service_request
            method = request.method.to_s.upcase
            allowed_methods = [ :post ]
            allowed_methods = allowed_methods.map{|m| m.to_s.upcase }
            if !allowed_methods.include?(method)
              render :text => "#{method} not supported", :status=>500
              return
            end
            exception = nil
            begin
              ws_request = discover_web_service_request(request)
            rescue Exception => e
              exception = e
            end
            if ws_request
              ws_response = nil
              exception = nil
              bm = Benchmark.measure do
                begin
                  ws_response = invoke_web_service_request(ws_request)
                rescue Exception => e
                  exception = e
                end
              end
              log_request(ws_request, request.raw_post)
              if exception
                logger.error(exception) unless logger.nil?
                send_web_service_error_response(ws_request, exception)
              else
                send_web_service_response(ws_response, bm.real)
              end
            else
              exception ||= DispatcherError.new("Malformed XML-RPC protocol message")
              logger.error(exception) unless logger.nil?
              send_web_service_error_response(ws_request, exception)
            end
          rescue Exception => e
            logger.error(e) unless logger.nil?
            send_web_service_error_response(ws_request, e)
          end

          def send_web_service_response(ws_response, elapsed=nil)
            log_response(ws_response, elapsed)
            options = { :type => ws_response.content_type, :disposition => 'inline' }
            send_data(ws_response.body, options)
          end

          def send_web_service_error_response(ws_request, exception)
            if ws_request
              unless self.class.web_service_exception_reporting
                exception = DispatcherError.new("Internal server error (exception raised)")
              end
              api_method = ws_request.api_method
              public_method_name = api_method ? api_method.public_name : ws_request.method_name
              return_type = ActionWebService::SignatureTypes.canonical_signature_entry(Exception, 0)
              ws_response = ws_request.protocol.encode_response(public_method_name + 'Response', exception, return_type, ws_request.protocol_options)
              send_web_service_response(ws_response)
            else
              if self.class.web_service_exception_reporting
                message = exception.message
                backtrace = "\nBacktrace:\n#{exception.backtrace.join("\n")}"
              else
                message = "Exception raised"
                backtrace = ""
              end
              render :status => 500, :text => "Internal protocol error: #{message}#{backtrace}"
            end
          end

          def web_service_direct_invoke(invocation)
            invocation.method_named_params.each do |name, value|
              params[name] = value
            end
            web_service_direct_invoke_without_controller(invocation)
          end

          def log_request(ws_request, body)
            unless logger.nil?
              name = ws_request.method_name
              api_method = ws_request.api_method
              params = ws_request.method_params
              if api_method && api_method.expects
                params = api_method.expects.zip(params).map{ |type, param| "#{type.name}=>#{param.inspect}" }
              else
                params = params.map{ |param| param.inspect }
              end
              service = ws_request.service_name
              logger.debug("\nWeb Service Request: #{name}(#{params.join(", ")}) Entrypoint: #{service}")
              logger.debug(indent(body))
            end
          end

          def log_response(ws_response, elapsed=nil)
            unless logger.nil?
              elapsed = (elapsed ? " (%f):" % elapsed : ":")
              logger.debug("\nWeb Service Response" + elapsed + " => #{ws_response.return_value.inspect}")
              logger.debug(indent(ws_response.body))
            end
          end

          def indent(body)
            body.split(/\n/).map{|x| "  #{x}"}.join("\n")
          end
      end
    end
  end
end
