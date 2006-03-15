require File.dirname(__FILE__) + '/../test_helper'

class DeliciousTest < Test::Unit::TestCase

  def setup
    @delicious = Delicious.new("", false)
    @delicious.send(:parse, fixture)
  end

  def test_parser
    assert_equal 3, @delicious.items.size
  end

  def test_fields
    assert_equal "del.icio.us/shanev", @delicious.title
    assert_equal "http://del.icio.us/shanev", @delicious.link
  end

  def test_items
    assert_equal "Guide to Using XMLHttpRequest (with Baby Steps)", @delicious.items[0].title
    assert_equal "http://www.webpasties.com/xmlHttpRequest/", @delicious.items[0].link
  end

  private

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
