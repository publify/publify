xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.rsd "version"=>"1.0", "xmlns"=>"http://archipelago.phrasewise.com/rsd" do
  xml.service do
    xml.engineName "Typo"
    xml.engineLink "http://www.typosphere.org"
    xml.homePageLink url_for(:controller => "articles")
    xml.apis do
      xml.api "name" => "Movable Type", "preferred"=>"true",
              "apiLink" => url_for(:controller => "backend", :action => "xmlrpc", :only_path => false),
              "blogID" => "1"
      xml.api "name" => "MetaWeblog", "preferred"=>"false",
              "apiLink" => url_for(:controller => "backend", :action => "xmlrpc", :only_path => false),
              "blogID" => "1"
      xml.api "name" => "Blogger", "preferred"=>"false",
              "apiLink" => url_for(:controller => "backend", :action => "xmlrpc", :only_path => false),
              "blogID" => "1"
    end
  end
end
