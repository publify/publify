# Typo-filter-amazon

class Typo
  class Textfilter
    class Amazon < TextFilterPlugin::PostProcess
      plugin_display_name "Amazon"
      plugin_description "Automatically turn amazon:ASIN URLs into affiliate links to Amazon items using your Amazon Associate ID"

      def self.filtertext(blog, content, text, params)
        associateid = config_value(params,'amazon-associate-id')
        domain_suffix = config_value(params,'amazon-domain-suffix')
        content.whiteboard[:asins] = []
        text.gsub(/<a href="amazon:([^"]+)"/) do |match|
          content.whiteboard[:asins] = content.whiteboard[:asins].to_a | [$1]
          "<a href=\"http://www.amazon.#{domain_suffix}/exec/obidos/ASIN/#{$1}/#{associateid}\""
        end
      end

      def self.default_config
        {"amazon-associate-id" => {:default => "",
                                   :description => "Amazon Associate ID",
                                   :help => "Your Amazon Associate's ID (see http://amazon.com/associates).  Typo's Amazon filter will automatically add this ID to all amazon:ASIN URLs that you create."},
          "amazon-domain-suffix" => {:default => "com",
                                   :description => "Amazon Domain Suffix",
                                   :help => "Your Amazon Domain Suffix depends on the language or country you live in."}
                                   }
      end

      def self.help_text
        %{
You can use `amazon:XXXX`-style URLs to refer to items for sale on
[Amazon.com](http://www.amazon.com).  If you provide an Amazon associate
ID in the filter configuration, then each of these URLs will be tagged
with your associate ID and you'll make money if someone buys an item
while using your link.  Example:

    <a href="amazon:097669400X">

turns into

    <a href="http://www.amazon.com/.../097669400X/scottstuff-20">}
      end
    end
  end
end