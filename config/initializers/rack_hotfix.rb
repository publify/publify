# TODO: Can be removed after updating to rack 1.3.0
module Rack
  module Utils
    def escape(s)
      CGI.escape(s.to_s)
    end
    def unescape(s)
      CGI.unescape(s)
    end
  end
end

