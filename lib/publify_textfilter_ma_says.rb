class PublifyApp
  class Textfilter
    class MaSays< TextFilterPlugin::MacroPost
      plugin_display_name "Ma Says"
      plugin_description "Insert an Ma Says snippet"

      def self.help_text
        %{
You can use `<publify:masays>` to display a Ma Says snippet.  Example:

    <publify:masays url="https://www.moneyadviceservice.org.uk/en/campaigns/saving-for-a-holiday">
      Saving for a Holiday
    </publify:masays>}
      end

      def self.macrofilter(_, _, attrib, _, text)
        url = attrib['url']

        "<div class=\"snippet next-steps\">
           <div class=\"next-steps__heading\">
             <span>MA</span> says
           </div>

           <a data-ck href=\"#{url}\" class=\"next-steps__container-link\">
             <div class=\"next-steps__text\">#{text}</div>
             <div class=\"next-steps__arrow-container\">
               <svg xmlns=\"http://www.w3.org/2000/svg\" class=\"next-steps__arrow\" version=\"1.1\" x=\"0px\" y=\"0px\" viewBox=\"46.9 -3.6 36 57.1\" enable-background=\"new 46.9 -3.6 36 57.1\" xml:space=\"preserve\">
                 <polyline class=\"next-steps__arrow-path\" stroke-width=\"9\" stroke-miterlimit=\"10\" points=\"50,0 76,25 50,50 \"/>
               </svg>
             </div>
           </a>
         </div>"
      end
    end
  end
end
