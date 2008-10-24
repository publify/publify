module CodeRay
module Scanners
  
  # YAML Scanner
  #
  # Based on the YAML scanner from Syntax by Jamis Buck.
  class YAML < Scanner
    
    register_for :yaml
    file_extension 'yml'
    
    def scan_tokens tokens, options
      
      value_expected = nil
      states = :initial
      
      until eos?
        
        kind = nil
        match = nil
        
        if match = scan(/\s+/)
          kind = :space
          state = :initial if match.index(?\n)
          
        elsif match = scan(/#.*/)
          kind = :comment
          
        elsif bol? and case
          when scan(/---/)
            kind = :tag
          end
        
        elsif state == :value and case
          when scan(/(?![!*&]).+(?=$|\s+#)/)
            kind = :string
          end
          
        elsif case
          when match = scan(/[-:](?= )/)
            state = :value if state == :colon && (match == ':' || match == '-')
            kind = :operator
          when match = scan(/[,{}\[\]]/)
            kind = :operator
          when state == :initial && scan(/\w+(?=:)/)
            kind = :key
            state = :colon
          when state == :initial && match = scan(/(?:"[^"]*"|'[^']*')(?=:)/)
            tokens << [:open, :key]
            tokens << [match[0,1], :delimiter]
            tokens << [match[1..-2], :content]
            tokens << [match[-1,1], :delimiter]
            tokens << [:close, :key]
            state = :colon
            next
          when scan(/(![\w\/]+)(:([\w:]+))?/)
            tokens << [self[1], :type]
            if self[2]
              tokens << [':', :operator]
              tokens << [self[3], :class]
            end
            next
          when scan(/&\S+/)
            kind = :variable
          when scan(/\*\w+/)
            kind = :global_variable
          when scan(/\d\d:\d\d:\d\d/)
            kind = :oct
          when scan(/\d\d\d\d-\d\d-\d\d\s\d\d:\d\d:\d\d(\.\d+)? [-+]\d\d:\d\d/)
            kind = :oct
          when scan(/:\w+/)
            kind = :symbol
          when scan(/[^:\s]+/)
            kind = :string
          # when scan(/>-?/)
          #   kind = :punct
          #   kind = :normal, scan(/.*$/)
          #   append getch until eos? || bol?
          #   return if eos?
          #   indent = check(/ */)
          #   kind = :string
          #   loop do
          #     line = check_until(/[\n\r]|\Z/)
          #     break if line.nil?
          #     if line.chomp.length > 0
          #       this_indent = line.chomp.match( /^\s*/ )[0]
          #       break if this_indent.length < indent.length
          #     end
          #     append scan_until(/[\n\r]|\Z/)
          #   end
          end
          
        else
          getch
          kind = :error
          
        end
        
        match ||= matched
        
        raise_inspect 'Error token %p in line %d' % [[match, kind], line], tokens if $DEBUG && !kind
        raise_inspect 'Empty token', tokens unless match
        
        tokens << [match, kind]
        
      end
      
      tokens
    end
    
  end
  
end
end
