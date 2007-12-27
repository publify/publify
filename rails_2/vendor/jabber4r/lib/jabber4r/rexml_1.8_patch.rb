if RUBY_VERSION=="1.8.0"
  module REXML
    module Parsers
      class BaseParser
        # Returns true if there are more events.  Synonymous with !empty?
        def has_next?
          return true if @closed # THIS WAS ADDED TO FIX PROBLEM
          @source.read if @source.buffer.size==0 and !@source.empty?
          (!@source.empty? and @source.buffer.strip.size>0) or @stack.size>0 or @closed
        end
      end
    end
  end
else
  puts "WARNING: rexml_1.8_patch is needed on Ruby 1.8.0 and not by Ruby #{RUBY_VERSION}"
end