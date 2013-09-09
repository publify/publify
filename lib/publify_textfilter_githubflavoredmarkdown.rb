class PublifyApp
  class Textfilter
    class Githubflavoredmarkdown < TextFilterPlugin::Markup
      plugin_display_name "GitHub Flavored Markdown"
      plugin_description 'GitHub Flavored Markdown markup language from <a href="https://help.github.com/articles/github-flavored-markdown">GitHub Help</a>'

      def self.help_text
        %{
[GFM](https://help.github.com/articles/github-flavored-markdown) is a simple text-to-HTML converter.

* `:tables`: parse tables, PHP-Markdown style.
* `:fenced_code_blocks`: parse fenced code blocks, PHP-Markdown
style. Blocks delimited with 3 or more `~` or backticks will be considered
as code, without the need to be indented. An optional language name may
be added at the end of the opening fence for the code block.
* `:autolink`: parse links even when they are not enclosed in `<>`
characters. Autolinks for the http, https and ftp protocols will be
automatically detected. Email addresses are also handled, and http
links without protocol, but starting with `www`.
* `:strikethrough`: parse strikethrough, PHP-Markdown style
Two `~` characters mark the start of a strikethrough,
e.g. `this is ~~good~~ bad`.

        }
      end

      def self.filtertext(blog,content,text,params)
        opt = {
          :tables             => true,
          :fenced_code_blocks => true,
          :autolink           => true,
          :strikethrough      => true
        }
        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,opt)
        markdown.render(text)

      end
    end
  end
end
