class Plugins::Textfilters::AmazonController < TextFilterPlugin::PostProcess
  def self.display_name
    "Amazon"
  end

  def self.description
    "Automatically turn amazon:ASIN URLs into affiliate links to Amazon items using your Amazon Associate ID"
  end

  def filtertext
    text=params[:text]
    associateid=(params[:filterparams])['amazon-associate-id']
    render :text => text.gsub(/<a href="amazon:([^"]+)"/,
      "<a href=\"http://www.amazon.com/exec/obidos/ASIN/\\1/#{associateid}\"")
  end

  def self.default_config
    {"amazon-associate-id" => {:default => "", 
                               :description => "Amazon Associate ID",
                               :help => "Your Amazon Associate's ID (see http://amazon.com/associates).  Typo's Amazon filter will automatically add this ID to all amazon:ASIN URLs that you create."}}
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
       
    <a href="http://www.amazon.com/exec/obidos/ASIN/097669400X/scottstuff-20">}
  end
end
