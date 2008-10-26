require 'coderay'

class Typo
  class Textfilter
    class Code < TextFilterPlugin::MacroPre
      plugin_display_name "Code"
      plugin_description "Apply coderay highlighting to a code block"

      DEFAULT_OPTIONS = {:css => :class, 
        :wrap => :div, 
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
`ruby`, `C`, `Delphi`, `HTML`, `RHTML`, `CSS`, `Diff`, `Java`, `Javascript` and `yaml`.  Other languages will format correctly but will not
have syntax highlighting.
* **linenumber**.  Turns on line numbering.  Use `linenumber="true"` to enable.
* **title**.  Adds a title block to the top of the code block.
* **class**.  Adds a new CSS class to the wrapper around the code block.
}
      end

      def self.macrofilter(blog, content, attrib, params, text="")
        lang       = attrib['lang']
        title      = attrib['title']
        cssclass   = attrib['class']
        options = DEFAULT_OPTIONS
        if attrib['linenumber']
          options[:line_numbers] = :table
        end

        text = text.to_s.gsub(/\r/,'').gsub(/\A\n/,'').chomp

        text = CodeRay.scan(text, lang.to_sym).html(options)
        text = "<notextile>#{text}</notextile>"

        if(title)
          titlecode="<div class=\"codetitle\">#{title}</div>"
        else
          titlecode=''
        end

        "<div class='CodeRay'>#{titlecode}#{text}</div>"
      end
    end
  end
end
