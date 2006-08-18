require 'syntax/convertors/html'

class Typo
  class Textfilter
    class Code < TextFilterPlugin::MacroPre
      plugin_display_name "Code"
      plugin_description "Apply syntax highlighting to a code block"

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

This uses the Ruby [Syntax](http://syntax.rubyforge.org/) module.  Options:

* **lang**.  Sets the programming language.  Currently supported languages are
`ruby`, `yaml`, and `xml`.  Other languages will format correctly but will not
have syntax highlighting.
* **linenumber**.  Turns on line numbering.  Use `linenumber="true"` to enable.
* **title**.  Adds a title block to the top of the code block.
* **class**.  Adds a new CSS class to the wrapper around the code block.
}
      end

      def self.macrofilter(blog,content,attrib,params,text="")
        lang       = attrib['lang'] || 'default'
        title      = attrib['title']
        cssclass   = attrib['class']
        linenumber = attrib['linenumber']

        text = text.to_s.gsub(/\r/,'').gsub(/\A\n/,'').chomp

        convertor = Syntax::Convertors::HTML.for_syntax lang
        text = convertor.convert(text)
        text.gsub!(/<pre>/,"<pre><code class=\"typocode_#{lang} #{cssclass}\"><notextile>")
        text.gsub!(/<\/pre>/,"</notextile></code></pre>")

        if(linenumber)
          lines = text.split(/\n/).size
          linenumbers = (1..lines).to_a.collect{|line| line.to_s}.join("\n")

          text = "<table class=\"typocode_linenumber\"><tr><td class=\"lineno\">\n<pre>\n#{linenumbers}\n</pre>\n</td><td width=\"100%\">#{text}</td></tr></table>"
        end

        if(title)
          titlecode="<div class=\"codetitle\">#{title}</div>"
        else
          titlecode=''
        end

        "<div class=\"typocode\">#{titlecode}#{text}</div>"
      end
    end
  end
end
