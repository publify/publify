# frozen_string_literal: true

require "coderay"
require "htmlentities"

class PublifyApp
  class Textfilter
    class Code < TextFilterPlugin::MacroPre
      plugin_display_name "Code"
      plugin_description "Apply coderay highlighting to a code block"

      DEFAULT_OPTIONS = { css: :class,
                          wrap: :span,
                          line_numbers: nil,
                          tab_width: 2,
                          bold_every: 5,
                          hint: false,
                          line_number_start: 1 }.freeze

      def self.help_text
        %{
You can use `<publify:code>` to include syntax-highlighted code blocks.  Example:

    <publify:code lang="ruby">
    class Foo
      def bar
        "abcde"
      end
    end
    </publify:code>

This uses the Ruby [Syntax](http://coderay.rubychan.de) module.  Options:

* **lang**.  Sets the programming language.  Currently supported languages are
*C, C++ (&#42;), CSS, Delphi, diff, Groovy (&#42;), HTML, Java, JavaScript, JSON,
PHP (&#42;), Python (&#42;), RHTML, Ruby, Scheme, SQL (&#42;), XHTML, XML, YAML.
&#42; Only available in CodeRay >= 0.9.1
* **linenumber**.  Turns on line numbering.  Use `linenumber="true"` to enable.
* **title**.  Adds a title block to the top of the code block.
}
      end

      def self.macrofilter(attrib, text = "")
        lang = attrib["lang"]
        title = attrib["title"]
        options = if attrib["linenumber"] == "true"
                    DEFAULT_OPTIONS.merge(line_numbers: :table,
                                          wrap: :div)
                  else
                    DEFAULT_OPTIONS
                  end

        text = text.to_s.delete("\r").delete_prefix("\n").chomp

        begin
          text = CodeRay.scan(text, lang.downcase.to_sym).span(options)
        rescue
          text = HTMLEntities.new("xhtml1").encode(text)
        end

        titlecode = if title
                      "<div class=\"codetitle\">#{title}</div>"
                    else
                      ""
                    end

        "<div class=\"CodeRay\"><pre>#{titlecode}#{text}</pre></div>"
      end
    end
  end
end
