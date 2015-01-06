class PublifyApp
  class Textfilter
    class MaSays< TextFilterPlugin::MacroPost
      plugin_display_name "Ma Says"
      plugin_description "Insert an Ma Says snippet"

      def self.help_text
        %{
You can use the following code to display a Ma Says snippet. Example:

<hr class="snippet" data-snippet-name="masays" data-snippet-text="Saving for a Holiday" data-snippet-url="https://www.moneyadviceservice.org.uk/en/campaigns/saving-for-a-holiday" />
}
      end

      def self.macrofilter(_, _, attrib, _)
        url = attrib['data-snippet-url']
        text = attrib['data-snippet-text']

        "<div class=\"snippet next-steps\">
           <div class=\"next-steps__heading\">
             <span>MA</span> says
           </div>

           <a href=\"#{url}\" class=\"next-steps__container-link\">
             <div class=\"next-steps__text\">#{text}</div>
             <div class=\"next-steps__arrow-container\">
               <svg xmlns=\"http://www.w3.org/2000/svg\" class=\"next-steps__arrow\" version=\"1.1\" x=\"0px\" y=\"0px\" viewBox=\"46.9 -3.6 36 57.1\" enable-background=\"new 46.9 -3.6 36 57.1\" xml:space=\"preserve\">
                 <polyline class=\"next-steps__arrow-path\" stroke-width=\"9\" stroke-miterlimit=\"10\" points=\"50,0 76,25 50,50 \"/>
               </svg>
             </div>
           </a>
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
