# by Josh Goebel
module CodeRay module Scanners
  
  class SQL < Scanner

    register_for :sql
    
    RESERVED_WORDS = %w(
      create table index trigger drop primary key set select
      insert update delete replace into
      on from values before and or if exists case when
      then else as group order by avg where
      join inner outer union engine not
      like
    )
    
    PREDEFINED_TYPES = %w(
      char varchar enum binary text tinytext mediumtext
      longtext blob tinyblob mediumblob longblob timestamp
      date time datetime year double decimal float int
      integer tinyint mediumint bigint smallint unsigned bit
      bool boolean
    )
    
    PREDEFINED_FUNCTIONS = %w( sum cast abs pi count min max avg )
    
    DIRECTIVES = %w( auto_increment unique default charset )

    PREDEFINED_CONSTANTS = %w( null true false )
    
    IDENT_KIND = CaseIgnoringWordList.new(:ident).
      add(RESERVED_WORDS, :reserved).
      add(PREDEFINED_TYPES, :pre_type).
      add(PREDEFINED_CONSTANTS, :pre_constant).
      add(PREDEFINED_FUNCTIONS, :predefined).
      add(DIRECTIVES, :directive)
    
    ESCAPE = / [rbfnrtv\n\\\/'"] | x[a-fA-F0-9]{1,2} | [0-7]{1,3} /x
    UNICODE_ESCAPE =  / u[a-fA-F0-9]{4} | U[a-fA-F0-9]{8} /x

    def scan_tokens tokens, options

      state = :initial
      string_type = nil
      string_content = ''

      until eos?

        kind = nil
        match = nil

        if state == :initial
          
          if scan(/ \s+ | \\\n /x)
            kind = :space
          
          elsif scan(/^(?:--\s|#).*/)
            kind = :comment

          elsif scan(%r! /\* (?: .*? \*/ | .* ) !mx)
            kind = :comment

          elsif scan(/ [-+*\/=<>;,!&^|()\[\]{}~%] | \.(?!\d) /x)
            kind = :operator
            
          elsif match = scan(/ [A-Za-z_][A-Za-z_0-9]* /x)
            kind = IDENT_KIND[match.downcase]
            
          elsif match = scan(/[`"']/)
            tokens << [:open, :string]
            string_type = matched
            state = :string
            kind = :delimiter
            
          elsif scan(/0[xX][0-9A-Fa-f]+/)
            kind = :hex
            
          elsif scan(/0[0-7]+(?![89.eEfF])/)
            kind = :oct
            
          elsif scan(/\d+(?![.eEfF])/)
            kind = :integer
            
          elsif scan(/\d[fF]?|\d*\.\d+(?:[eE][+-]?\d+)?[fF]?|\d+[eE][+-]?\d+[fF]?/)
            kind = :float

          else
            getch
            kind = :error
            
          end
          
        elsif state == :string
          if match = scan(/[^\\"'`]+/)
            string_content << match
            next
          elsif match = scan(/["'`]/)
            if string_type == match
              if peek(1) == string_type  # doubling means escape
                string_content << string_type << getch
                next
              end
              unless string_content.empty?
                tokens << [string_content, :content]
                string_content = ''
              end
              tokens << [matched, :delimiter]
              tokens << [:close, :string]
              state = :initial
              string_type = nil
              next
            else
              string_content << match
            end
            next
          elsif scan(/ \\ (?: #{ESCAPE} | #{UNICODE_ESCAPE} ) /mox)
            unless string_content.empty?
              tokens << [string_content, :content]
              string_content = ''
            end
            kind = :char
          elsif match = scan(/ \\ . /mox)
            string_content << match
            next
          elsif scan(/ \\ | $ /x)
            unless string_content.empty?
              tokens << [string_content, :content]
              string_content = ''
            end
            kind = :error
            state = :initial
          else
            raise "else case \" reached; %p not handled." % peek(1), tokens
          end
          
        else
          raise 'else-case reached', tokens
          
        end
        
        match ||= matched
#        raise [match, kind], tokens if kind == :error
        
        tokens << [match, kind]
        
      end
#      RAILS_DEFAULT_LOGGER.info tokens.inspect
      tokens
      
    end

  end

end end