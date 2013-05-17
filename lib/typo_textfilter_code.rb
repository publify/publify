require 'coderay'
require 'htmlentities'

class Typo
  class Textfilter
    class Code < TextFilterPlugin::MacroPre
      plugin_display_name "Code"
      plugin_description "Apply coderay highlighting to a code block"

      DEFAULT_OPTIONS = {:css => :class,
        :wrap => :span,
        :line_numbers => nil,
        :tab_width => 2,
        :bold_every => 5,
        :hint => false,
        :line_number_start => 1}

      def self.help_text
        %{
You can use `<typo:code>` to include syntax-highlighted code blocks.  Example:

    <typo:code lang="ruby">
    class Foo
      def bar
        "abcde"
      end
    end
    </typo:code>

This uses the Ruby [Syntax](http://coderay.rubychan.de) module.  Options:

* **lang**.  Sets the programming language.  Currently supported languages are
*C, C++ (&#42;), CSS, Delphi, diff, Groovy (&#42;), HTML, Java, JavaScript, JSON,
PHP (&#42;), Python (&#42;), RHTML, Ruby, Scheme, SQL (&#42;), XHTML, XML, YAML.
&#42; Only available in CodeRay >= 0.9.1
* **linenumber**.  Turns on line numbering.  Use `linenumber="true"` to enable.
* **title**.  Adds a title block to the top of the code block.
}
      end

      def self.macrofilter(blog, content, attrib, params, text="")
        lang       = attrib['lang']
        title      = attrib['title']
        if attrib['linenumber'] == "true"
          options = DEFAULT_OPTIONS.merge(:line_numbers => :table,
                                  :wrap => :div)
        else
          options = DEFAULT_OPTIONS
        end

        text = text.to_s.gsub(/\r/,'').gsub(/\A\n/,'').chomp

        begin
          text = CodeRay.scan(text, lang.downcase.to_sym).span(options)
        rescue
          text = HTMLEntities.new("xhtml1").encode(text)
        end
        text = "<notextile>#{text}</notextile>"

        if(title)
          titlecode="<div class=\"codetitle\">#{title}</div>"
        else
          titlecode=''
        end

        "<div class=\"CodeRay\"><pre>#{titlecode}#{text}</pre></div>"
      end
    end
  end
end
