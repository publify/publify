class CGI
  attr_accessor :raw_post
  
  module QueryExtension
    def initialize_query()
      STDERR << "initialize_query"

      if ("POST" == env_table['REQUEST_METHOD']) and %r|\Amultipart/form-data.*boundary=\"?([^\";,]+)\"?|n.match(env_table['CONTENT_TYPE']) #"
        boundary = $1.dup
        @multipart = true
        @params       = read_multipart(boundary, Integer(env_table['CONTENT_LENGTH']))
      else
        @multipart    = false
        @raw_post     = get_post
        @params       = CGI::parse(@raw_post)
      end

      @cookies = CGI::Cookie::parse((env_table['HTTP_COOKIE'] or env_table['COOKIE']))
    end

    def get_post
      case env_table['REQUEST_METHOD']
      when "GET", "HEAD"
        if defined?(MOD_RUBY)
          Apache::request.args or ""
        else
          env_table['QUERY_STRING'] or ""
        end
      when "POST"
        stdinput.binmode if defined? stdinput.binmode
        stdinput.read(Integer(env_table['CONTENT_LENGTH'])) or ''
      else
        read_from_cmdline
      end    
    end

  end
  
end

module ActionController
  class CgiRequest < AbstractRequest #:nodoc:
    def raw_post
      cgi.raw_post
    end
  end    
end