module CodeRay  # :nodoc:
  
  # A little hack to enable CodeRay highlighting in RedCloth.
  # 
  # Usage:
  #  require 'coderay'
  #  require 'coderay/for_redcloth'
  #  RedCloth.new('@[ruby]puts "Hello, World!"@').to_html
  # 
  # Make sure you have RedCloth 4.0.3 activated, for example by calling
  #  require 'rubygems'
  # before RedCloth is loaded and before calling CodeRay.for_redcloth.
  module ForRedCloth
    
    def self.install
      gem 'RedCloth', '>= 4.0.3' rescue nil
      require 'redcloth'
      raise 'CodeRay.for_redcloth needs RedCloth 4.0.3 or later.' unless RedCloth::VERSION.to_s >= '4.0.3'
      RedCloth::TextileDoc.send :include, ForRedCloth::TextileDoc
      RedCloth::Formatters::HTML.module_eval do
        def unescape(html)
          replacements = {
            '&amp;' => '&',
            '&quot;' => '"',
            '&gt;' => '>',
            '&lt;' => '<',
          }
          html.gsub(/&(?:amp|quot|[gl]t);/) { |entity| replacements[entity] }
        end
        undef_method :code, :bc_open, :bc_close, :escape_pre
        def code(opts)  # :nodoc:
          opts[:block] = true
          if opts[:lang] && !filter_coderay
            require 'coderay'
            @in_bc ||= nil
            format = @in_bc ? :div : :span
            highlighted_code = CodeRay.encode opts[:text], opts[:lang], format, :stream => true
            highlighted_code.sub!(/\A<(span|div)/) { |m| m + pba(@in_bc || opts) }
            highlighted_code = unescape(highlighted_code) unless @in_bc
            highlighted_code
          else
            "<code#{pba(opts)}>#{opts[:text]}</code>"
          end
        end
        def bc_open(opts)  # :nodoc:
          opts[:block] = true
          @in_bc = opts
          opts[:lang] ? '' : "<pre#{pba(opts)}>"
        end
        def bc_close(opts)  # :nodoc:
          @in_bc = nil
          opts[:lang] ? '' : "</pre>\n"
        end
        def escape_pre(text)
          if @in_bc ||= nil
            text
          else
            html_esc(text, :html_escape_preformatted)
          end
        end
      end
    end

    module TextileDoc  # :nodoc:
      attr_accessor :filter_coderay
    end
    
  end
  
end

CodeRay::ForRedCloth.install