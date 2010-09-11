module ActionWebService # :nodoc:
  module Protocol # :nodoc:
    class ProtocolError < ActionWebServiceError # :nodoc:
    end

    class AbstractProtocol # :nodoc:
      def setup(controller)
      end

      def decode_action_pack_request(action_pack_request)
      end

      def decode_request(raw_request, service_name, protocol_options={})
      end

      def encode_request(method_name, params, param_types)
      end

      def decode_response(raw_response)
      end

      def encode_response(method_name, return_value, return_type, protocol_options={})
      end

      def register_api(api)
      end
    end

    class Request # :nodoc:
      attr :protocol
      attr_accessor :method_name
      attr_accessor :method_params
      attr :service_name
      attr_accessor :api
      attr_accessor :api_method
      attr :protocol_options

      def initialize(protocol, method_name, method_params, service_name, api=nil, api_method=nil, protocol_options=nil)
        @protocol = protocol
        @method_name = method_name
        @method_params = method_params
        @service_name = service_name
        @api = api
        @api_method = api_method
        @protocol_options = protocol_options || {}
      end
    end

    class Response # :nodoc:
      attr :body
      attr :content_type
      attr :return_value

      def initialize(body, content_type, return_value)
        @body = body
        @content_type = content_type
        @return_value = return_value
      end
    end
  end
end
