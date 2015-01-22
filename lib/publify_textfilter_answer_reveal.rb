require 'digest'

class PublifyApp
  class Textfilter
    class AnswerReveal < TextFilterPlugin::MacroPost
      plugin_display_name "Answer Reveal"
      plugin_description "Insert a answer reveal inline callout"

      def self.help_text
        %{
You can use the following code to display an inline callout snippet. Example:

<hr class="snippet" data-snippet-name="answerreveal" data-snippet-question="[ENTER QUESTION TEXT HERE]" data-snippet-answer="[ENTER ANSWER TEXT HERE]" data-snippet-callout-text="[ENTER CALLOUT TEXT HERE]" data-snippet-callout-url="[ENTER CALLOUT URL HERE]" />
        }
      end

      def self.macrofilter(_, _, attrib, _)
        question = attrib['data-snippet-text-question']
        answer = attrib['data-snippet-text-answer']
        callout_text = attrib['data-snippet-text-callout']
        callout_url = attrib['data-snippet-url-callout']

        answer = answer.gsub(/^/,"<p>").gsub(/\\n/,"</p><p>").gsub(/$/, "</p>")

        callout_id = Digest::SHA256.hexdigest answer

        "<div class=\"collapsible\">
          <h3 class=\"collapsible__heading\">#{question}</h3>
          <div class=\"collapsible__reveal\" data-dough-collapsable-target=\"answer_reveal_#{callout_id}\">
            #{answer}

            <hr class=\"snippet\" data-snippet-name=\"inlinecallout\" data-snippet-url=\"#{callout_url}\" data-snippet-text=\"#{callout_text}\" />
          </div>
          <div class=\"collapsible__trigger\" data-dough-component=\"Collapsable\" data-dough-collapsable-trigger=\"answer_reveal_#{callout_id}\">
            <span class=\"collapsible__trigger-text\">Reveal the answer</span>
            <span class=\"collapsible__trigger-text collapsible__trigger-text--hide\">Hide answer</span>
            <svg class=\"plus-icon\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" version=\"1.1\" viewBox=\"0 0 80 80\" xml:space=\"preserve\">
              <g class=\"plus-icon__origin\">
                <g class=\"plus-icon__lines\">
                  <circle class=\"plus-icon__circle\" cx=\"40\" cy=\"40\" r=\"40\"/>
                  <line fill=\"none\" class=\"plus-icon__line\" stroke-width=\"6\" stroke-miterlimit=\"10\" x1=\"40\" y1=\"25\" x2=\"40\" y2=\"55\"/>
                  <line class=\"plus-icon__line plus-icon__line--horizontal\" fill=\"none\" stroke-width=\"6\" stroke-miterlimit=\"10\" x1=\"25\" y1=\"40\" x2=\"55\" y2=\"40\"/>
                </g>
              </g>
            </svg>
          </div>
        </div>"
      end

      def self.filtertext(blog, content, text, params)
        filterparams = params[:filterparams]
        regex = /<hr class="snippet" data-snippet-name="#{short_name}"([ \t][^>]*)?\/>/m

        new_text = text.gsub(regex) do |match|
          macrofilter(blog,content,attributes_parse($1.to_s),params)
        end

        new_text
      end
    end
  end
end
