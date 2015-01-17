xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.rsd "version"=>"1.0", "xmlns"=>"http://archipelago.phrasewise.com/rsd" do
  xml.service do
    xml.engineName "Publify"
    xml.engineLink "http://www.publify.co"
    xml.homePageLink url_for(:controller => "articles")
  end
end
