# by Keith Pitt
module CodeRay
module Scanners
  
  class SQL < Scanner

    register_for :sql
    
    include Streamable

    RESERVED_WORDS = %w(
      all alter and any as asc at authid avg begin between 
      body bulk by case char check close cluster coalesce 
      collect comment commit compress connect constant create
      current currval cursor day declare default delete 
      desc distinct do drop else elsif end exception exclusive
      execute exists exit extends extract fetch for forall 
      from function goto group having heap hour if immediate in 
      index indicator insert interface intersect
      interval into is isolation java level like limited lock
      loop max min minus minute mlslabel mod mode month natural 
      naturaln new nextval nocopy not nowait null nullif
      number_base ocirowid of on opaque open operator option or 
      order organization others out package partition pctfree 
      pls_integer positive positiven pragma prior private procedure 
      public raise range raw real record ref release return reverse 
      rollback row rowid rownum rowtype savepoint second select
      separate set share space sql sqlcode sqlerrm start 
      stddev subtype successful sum synonym sysdate table then
      timezone_region timezone_abbr timezone_minute 
      to trigger true type uid union unique update 
      use user validate values variance view when 
      whenever where while with work write year zone
    )

    PREDEFINED_TYPES = %w(
      array bigint bit binary blob boolean binary_integer char
      character clob date decimal double float char_base
      int integer nchar nclob smallint timestamp long number
      timestamp_hour timestamp_minute varchar varying smallint
      varchar2 nvarchar money time
    )

    PREDEFINED_CONSTANTS = %w(
      NULL true false
    )

    IDENT_KIND = CaseIgnoringWordList.new(:ident).
      add(RESERVED_WORDS, :reserved).
      add(PREDEFINED_TYPES, :pre_type).
      add(PREDEFINED_CONSTANTS, :pre_constant)

    def scan_tokens tokens, options

      state = :initial
      
      until eos?

        kind = nil
        match = nil
        
        case state

        when :initial

          if scan(/ \s+ | \\\n /x)
            kind = :space

          elsif scan(%r! -- [^\n\\]* (?: \\. [^\n\\]* )* | /\* (?: .*? \*/ | .* ) !mx)
            kind = :comment

          elsif scan(/ [-+*\/=<>?:;,!&^|()~%]+ | \.(?!\d) /x)
            kind = :operator

          elsif match = scan(/ [A-Za-z_][A-Za-z_0-9]* /x)
            kind = IDENT_KIND[match]
            if kind == :ident and check(/:(?!:)/)
              match << scan(/:/)
              kind = :label
            end

          elsif match = scan(/'/)
            tokens << [:open, :string]
            state = :string
            kind = :delimiter

          elsif scan(/(?:\d+)(?![.eEfF])/)
            kind = :integer

          elsif scan(/\d[fF]?|\d*\.\d+(?:[eE][+-]?\d+)?[fF]?|\d+[eE][+-]?\d+[fF]?/)
            kind = :float

          else
            getch
            kind = :error

          end

        when :string
          if scan(/[^\\\n']+/)
            kind = :content
          elsif scan(/'/)
            tokens << ["'", :delimiter]
            tokens << [:close, :string]
            state = :initial
            next
          elsif scan(/ \\ (?: #{ESCAPE} | #{UNICODE_ESCAPE} ) /mox)
            kind = :char
          elsif scan(/ \\ | $ /x)
            tokens << [:close, :string]
            kind = :error
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

      if state == :string
        tokens << [:close, :string]
      end

      tokens
    end

  end

end
end
