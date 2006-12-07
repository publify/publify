require File.dirname(__FILE__) + '/../spec_helper'

context 'Given a parsed Delicious RDF fixture' do
  setup do
    @delicious = Delicious.new("", false)
    @delicious.send(:parse, fixture)
  end

  specify 'there should be three items' do
    @delicious.should_have(3).items
  end

  specify "title should be 'del.icio.us/shanev'" do
    @delicious.title.should == 'del.icio.us/shanev'
  end

  specify "link should be 'http://del.icio.us/shanev'" do
    @delicious.link.should == 'http://del.icio.us/shanev'
  end

  specify 'first item title should be "Guide to Using XMLHttpRequest (with Baby Steps)"' do
    @delicious.items.first.title.should == "Guide to Using XMLHttpRequest (with Baby Steps)"
  end

  specify 'first item link should be "http://www.webpasties.com/xmlHttpRequest/"' do
    @delicious.items.first.link.should == "http://www.webpasties.com/xmlHttpRequest/"
  end



  def fixture
    %{<?xml version="1.0" encoding="UTF-8"?>
    <rdf:RDF
     xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
     xmlns="http://purl.org/rss/1.0/"
     xmlns:taxo="http://purl.org/rss/1.0/modules/taxonomy/"
     xmlns:dc="http://purl.org/dc/elements/1.1/"
     xmlns:syn="http://purl.org/rss/1.0/modules/syndication/"
     xmlns:admin="http://webns.net/mvcb/"
    >

    <channel rdf:about="http://del.icio.us/shanev">
        <title>del.icio.us/shanev</title>
        <link>http://del.icio.us/shanev</link>
        <description></description>
        <items>
         <rdf:Seq>
          <rdf:li rdf:resource="http://www.webpasties.com/xmlHttpRequest/" />
          <rdf:li rdf:resource="http://www.w3schools.com/js/default.asp" />

          <rdf:li rdf:resource="http://www.feedfab.com/xmljs/" />
         </rdf:Seq>
        </items>
    </channel>

    <item rdf:about="http://www.webpasties.com/xmlHttpRequest/">
        <title>Guide to Using XMLHttpRequest (with Baby Steps)</title>
        <link>http://www.webpasties.com/xmlHttpRequest/</link>
        <dc:creator>shanev</dc:creator>
        <dc:date>2005-02-24T07:11Z</dc:date>
        <dc:subject>XMLHTTPRequest</dc:subject>

        <taxo:topics>
          <rdf:Bag>
            <rdf:li resource="http://del.icio.us/tag/XMLHTTPRequest" />
          </rdf:Bag>
        </taxo:topics>
        </item>

    <item rdf:about="http://www.w3schools.com/js/default.asp">
        <title>W3 Schools Javascript Tutorial</title>
        <link>http://www.w3schools.com/js/default.asp</link>
        <dc:creator>shanev</dc:creator>

        <dc:date>2005-02-24T04:03Z</dc:date>
        <dc:subject>javascript</dc:subject>
        <taxo:topics>
          <rdf:Bag>
            <rdf:li resource="http://del.icio.us/tag/javascript" />
          </rdf:Bag>
        </taxo:topics>
    </item>

    <item rdf:about="http://www.feedfab.com/xmljs/">
        <title>XMLHTTPRequest Library</title>

        <link>http://www.feedfab.com/xmljs/</link>
        <dc:creator>shanev</dc:creator>
        <dc:date>2005-02-22T21:36Z</dc:date>
        <dc:subject>XMLHTTPRequest</dc:subject>
        <taxo:topics>
          <rdf:Bag>
            <rdf:li resource="http://del.icio.us/tag/XMLHTTPRequest" />
          </rdf:Bag>
        </taxo:topics>
    </item>

    </rdf:RDF>
  }
  end
end
