module CodeRay
module Scanners

  class JavaScript < Scanner

    include Streamable

    register_for :java_script
    file_extension 'js'

    # The actual JavaScript keywords.
    KEYWORDS = %w[
      break case catch continue default delete do else
      false finally for function if in instanceof new null
      return switch throw true try typeof var void while with
    ]
    
    MAGIC_VARIABLES = %w[ this arguments ]  # arguments was introduced in JavaScript 1.4
    
    KEYWORDS_EXPECTING_VALUE = WordList.new.add %w[
      case delete in instanceof new return throw typeof while with
    ]
    
    # Reserved for future use.
    RESERVED_WORDS = %w[
      abstract boolean byte char class debugger double enum export extends
      final float goto implements import int interface long native package
      private protected public short static super synchronized throws transient
      volatile
    ]
    
    IDENT_KIND = WordList.new(:ident).
      add(RESERVED_WORDS, :reserved).
      add(MAGIC_VARIABLES, :local_variable).
      add(KEYWORDS, :keyword)

    ESCAPE = / [bfnrtv\n\\'"] | x[a-fA-F0-9]{1,2} | [0-7]{1,3} /x
    UNICODE_ESCAPE =  / u[a-fA-F0-9]{4} | U[a-fA-F0-9]{8} /x
    REGEXP_ESCAPE =  / [bBdDsSwW] /x
    STRING_CONTENT_PATTERN = {
      "'" => /[^\\']+/,
      '"' => /[^\\"]+/,
      '/' => /[^\\\/]+/,
    }

    def scan_tokens tokens, options

      state = :initial
      string_delimiter = nil
      value_expected = true
      key_expected = false

      until eos?

        kind = nil
        match = nil
        
        case state

        when :initial

          if match = scan(/ \s+ | \\\n /x)
            value_expected = true if !value_expected && match.index(?\n)
            tokens << [match, :space]
            next

          elsif scan(%r! // [^\n\\]* (?: \\. [^\n\\]* )* | /\* (?: .*? \*/ | .* ) !mx)
            value_expected = true
            kind = :comment

          elsif check(/\d/)
            key_expected = value_expected = false
            if scan(/0[xX][0-9A-Fa-f]+/)
              kind = :hex
            elsif scan(/(?>0[0-7]+)(?![89.eEfF])/)
              kind = :oct
            elsif scan(/\d+[fF]|\d*\.\d+(?:[eE][+-]?\d+)?[fF]?|\d+[eE][+-]?\d+[fF]?/)
              kind = :float
            elsif scan(/\d+/)
              kind = :integer
            end
            
          elsif match = scan(/ [-+*=<>?:;,!&^|(\[{~%]+ | \.(?!\d) /x)
            value_expected = true
            last_operator = match[-1]
            key_expected = (last_operator == ?{) || (last_operator == ?,)
            kind = :operator

          elsif scan(/ [)\]}]+ /x)
            key_expected = value_expected = false
            kind = :operator

          elsif match = scan(/ [$a-zA-Z_][A-Za-z_0-9$]* /x)
            kind = IDENT_KIND[match]
            value_expected = (kind == :keyword) && KEYWORDS_EXPECTING_VALUE[match]
            if kind == :ident
              if match.index(?$)
                kind = :predefined
              elsif key_expected && check(/\s*:/)
                kind = :key
              end
            end
            key_expected = false

          elsif match = scan(/["']/)
            tokens << [:open, :string]
            state = :string
            string_delimiter = match
            kind = :delimiter

          elsif value_expected && (match = scan(/\/(?=\S)/))
            tokens << [:open, :regexp]
            state = :regexp
            string_delimiter = '/'
            kind = :delimiter

          elsif scan(/ \/ /x)
            value_expected = true
            key_expected = false
            kind = :operator

          else
            getch
            kind = :error

          end

        when :string, :regexp
          if scan(STRING_CONTENT_PATTERN[string_delimiter])
            kind = :content
          elsif match = scan(/["'\/]/)
            tokens << [match, :delimiter]
            if state == :regexp
              modifiers = scan(/[gim]+/)
              tokens << [modifiers, :modifier] if modifiers && !modifiers.empty?
            end
            tokens << [:close, state]
            string_delimiter = nil
            key_expected = value_expected = false
            state = :initial
            next
          elsif state == :string && (match = scan(/ \\ (?: #{ESCAPE} | #{UNICODE_ESCAPE} ) /mox))
            if string_delimiter == "'" && !(match == "\\\\" || match == "\\'")
              kind = :content
            else
              kind = :char
            end
          elsif state == :regexp && scan(/ \\ (?: #{ESCAPE} | #{REGEXP_ESCAPE} | #{UNICODE_ESCAPE} ) /mox)
            kind = :char
          elsif scan(/\\./m)
            kind = :content
          elsif scan(/ \\ | $ /x)
            tokens << [:close, :delimiter]
            kind = :error
            key_expected = value_expected = false
            state = :initial
          else
            raise_inspect "else case \" reached; %p not handled." % peek(1), tokens
          end

        else
          raise_inspect 'Unknown state', tokens

        end

        match ||= matched
        if $DEBUG and not kind
          raise_inspect 'Error token %p in line %d' %
            [[match, kind], line], tokens
        end
        raise_inspect 'Empty token', tokens unless match
        
        tokens << [match, kind]

      end

      if [:string, :regexp].include? state
        tokens << [:close, state]
      end

      tokens
    end

  end

end
end
