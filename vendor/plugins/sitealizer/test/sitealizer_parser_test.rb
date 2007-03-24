require 'test/unit'
require 'cgi'
require File.dirname(__FILE__) + '/../lib/sitealizer/parser'

class SitealizerParserTest < Test::Unit::TestCase
  
  def test_user_agent_platform
    user_agent = "(Macintosh; U; PPC Mac OS X; en)"
    assert_equal "Macintosh", Sitealizer::Parser::UserAgent.get_platform(user_agent)
    
    user_agent = "(Windows; U; Windows NT 5.1; nl; rv:1.8)"
    assert_equal "Windows", Sitealizer::Parser::UserAgent.get_platform(user_agent)
    
    user_agent = "(X11; U; Linux i686; en-US; rv:1.8.0.2)"
    assert_equal "Linux", Sitealizer::Parser::UserAgent.get_platform(user_agent)
    
    user_agent = "(compatible; MSIE 5.0; SunOS 5.9 sun4u; X11)"
    assert_equal "Sun Solaris", Sitealizer::Parser::UserAgent.get_platform(user_agent)
    
    user_agent = "X11; U; FreeBSD i386; en-US; rv:1.7.8)"
    assert_equal "FreeBSD", Sitealizer::Parser::UserAgent.get_platform(user_agent)
    
    user_agent = "Some unknown user agent"
    assert_equal "Other", Sitealizer::Parser::UserAgent.get_platform(user_agent)
  end
  
  def test_user_agent_browser
    user_agent = "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/418.9.1 (KHTML, like Gecko) Safari/419.3"
    assert_equal({:type => 'Safari', :version => nil}, 
                 Sitealizer::Parser::UserAgent.browser_info(user_agent))
    
    user_agent = "Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1) Gecko/20061026 BonEcho/2.0"
    assert_equal({:type => 'Firefox BonEcho', :version => '2.0'}, 
                 Sitealizer::Parser::UserAgent.browser_info(user_agent))

    user_agent = "Mozilla/4.0 (compatible; MSIE 7.0b; Windows NT 6.0)"
    assert_equal({:type => 'MSIE', :version => '7.0'}, 
                 Sitealizer::Parser::UserAgent.browser_info(user_agent))
    
    user_agent = "Mozilla/5.0 (Windows; U; Windows NT 5.1; nl; rv:1.8) Gecko/20051107 Firefox/1.5"
    assert_equal({:type => 'Firefox', :version => '1.5'}, 
                 Sitealizer::Parser::UserAgent.browser_info(user_agent))
    
    user_agent = "Mozilla/5.0 (Windows NT 5.1; U; en) Opera 8.50"
    assert_equal({:type => 'Opera', :version => '8.50'}, 
                 Sitealizer::Parser::UserAgent.browser_info(user_agent))
    
    user_agent = "Mozilla/4.0 (compatible; MSIE 6.0; America Online Browser 1.1; rev1.2; Windows NT 5.1;)"
    assert_equal({:type => 'AOL', :version => '1.1'}, 
                 Sitealizer::Parser::UserAgent.browser_info(user_agent))
    
    user_agent = "Mozilla/4.0 (compatible; MSIE 5.5; AOL 6.0; Windows 98)"
    assert_equal({:type => 'AOL', :version => '6.0'}, 
                 Sitealizer::Parser::UserAgent.browser_info(user_agent))
    
    user_agent = "Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.0.3) Gecko/20060427 Camino/1.0.1"
    assert_equal({:type => 'Camino', :version => '1.0.1'}, 
                 Sitealizer::Parser::UserAgent.browser_info(user_agent))
    
    user_agent = "Mozilla/5.0 (compatible; Konqueror/3.4; Linux) KHTML/3.4.2 (like Gecko)"
    assert_equal({:type => 'Konqueror', :version => '3.4'}, 
                 Sitealizer::Parser::UserAgent.browser_info(user_agent))
    
    user_agent = "Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.7.13) Gecko/20050610 K-Meleon/0.9"
    assert_equal({:type => 'K-Meleon', :version => '0.9'}, 
                 Sitealizer::Parser::UserAgent.browser_info(user_agent))
    
    user_agent = "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.4) Gecko/20030624 Netscape/7.1 (ax)"
    assert_equal({:type => 'Netscape', :version => '7.1'}, 
                 Sitealizer::Parser::UserAgent.browser_info(user_agent))
    
    user_agent = "Mozilla/4.0 (PSP (PlayStation Portable); 2.00)"
    assert_equal({:type => 'PlayStation Portable (PSP)', :version => '2.00'}, 
                 Sitealizer::Parser::UserAgent.browser_info(user_agent))
    
    user_agent = "Mozilla/5.0 (PLAYSTATION 3; 1.00)"
    assert_equal({:type => 'PlayStation 3', :version => '1.00'}, 
                 Sitealizer::Parser::UserAgent.browser_info(user_agent))
    
    user_agent = "Lynx/2.8.5rel.1 libwww-FM/2.14 SSL-MM/1.4.1 OpenSSL/0.9.8a"
    assert_equal({:type => 'Lynx', :version => '2.8.5'}, 
                 Sitealizer::Parser::UserAgent.browser_info(user_agent))
    
    user_agent = "Another user agent"
    assert_equal({:type => 'Other', :version => nil}, 
                 Sitealizer::Parser::UserAgent.browser_info(user_agent))
    
  end
  
  def test_keyword_get_terms
    referer = "http://search.yahoo.com/search?p=sitealizer&fr=yfp-t-501&toggle=1&cop=mss&ei=UTF-8"
    assert_equal "sitealizer", Sitealizer::Parser::Keyword.get_terms(referer)
    
    referer = "http://search.msn.com/results.aspx?srch=105&FORM=AS5&q=sitealizer"
    assert_equal "sitealizer", Sitealizer::Parser::Keyword.get_terms(referer)
    
    referer = "http://www.google.com/search?sourceid=navclient&ie=UTF-8&rlz=1T4DMUS_enUS202US205&q=sitealizer"
    assert_equal "sitealizer", Sitealizer::Parser::Keyword.get_terms(referer)
    
    referer = "http://search.aol.com/aolcom/search?invocationType=topsearchbox.search&query=sitealizer"
    assert_equal "sitealizer", Sitealizer::Parser::Keyword.get_terms(referer)
    
    referer = "http://alltheweb.com/search?cat=web&cs=iso88591&q=sitealizer&rys=0&itag=crv&_sb_lang=pref"
    assert_equal "sitealizer", Sitealizer::Parser::Keyword.get_terms(referer)
    
    referer = "http://www.ask.com/web?q=sitealizer&qsrc=0&o=333&l=dir"
    assert_equal "sitealizer", Sitealizer::Parser::Keyword.get_terms(referer)
    
    referer = "http://www.altavista.com/web/results?itag=ody&q=sitealizer&kgs=1&kls=0"
    assert_equal "sitealizer", Sitealizer::Parser::Keyword.get_terms(referer)
  end
  
  def test_keyword_get_domain
    referer = "http://search.yahoo.com/search?p=sitealizer&fr=yfp-t-501&toggle=1&cop=mss&ei=UTF-8"
    assert_equal "search.yahoo.com", Sitealizer::Parser::Keyword.get_domain(referer, 'localhost')
    
    referer = "http://search.msn.com/results.aspx?srch=105&FORM=AS5&q=sitealizer"
    assert_equal "search.msn.com", Sitealizer::Parser::Keyword.get_domain(referer, 'localhost')
    
    referer = "http://www.google.com/search?sourceid=navclient&ie=UTF-8&rlz=1T4DMUS_enUS202US205&q=sitealizer"
    assert_equal "www.google.com", Sitealizer::Parser::Keyword.get_domain(referer, 'localhost')
    
    referer = "http://search.aol.com/aolcom/search?invocationType=topsearchbox.search&query=sitealizer"
    assert_equal "search.aol.com", Sitealizer::Parser::Keyword.get_domain(referer, 'localhost')
    
    referer = "http://alltheweb.com/search?cat=web&cs=iso88591&q=sitealizer&rys=0&itag=crv&_sb_lang=pref"
    assert_equal "alltheweb.com", Sitealizer::Parser::Keyword.get_domain(referer, 'localhost')
    
    referer = "http://www.ask.com/web?q=sitealizer&qsrc=0&o=333&l=dir"
    assert_equal "www.ask.com", Sitealizer::Parser::Keyword.get_domain(referer, 'localhost')
    
    referer = "http://www.altavista.com/web/results?itag=ody&q=sitealizer&kgs=1&kls=0"
    assert_equal "www.altavista.com", Sitealizer::Parser::Keyword.get_domain(referer, 'localhost')
  end
  
  def test_robot_get_name
    user_agent = "Atomz/1.0"
    assert_equal "Atomz.com", Sitealizer::Parser::Robot.get_name(user_agent)
    
    user_agent = "Googlebot/2.X (+http://www.googlebot.com/bot.html)"
    assert_equal "Googlebot", Sitealizer::Parser::Robot.get_name(user_agent)
    
    user_agent = "InfoSeek Robot 1.0"
    assert_equal "InfoSeek", Sitealizer::Parser::Robot.get_name(user_agent)
    
    user_agent = "Mozilla/2.0 (compatible; Ask Jeeves/Teoma)"
    assert_equal "Ask Jeeves", Sitealizer::Parser::Robot.get_name(user_agent)
    
    user_agent = "Lycos/x."
    assert_equal "Lycos", Sitealizer::Parser::Robot.get_name(user_agent)
    
    user_agent = "MSNBOT/0.1 (http://search.msn.com/msnbot.htm)"
    assert_equal "MSNBot", Sitealizer::Parser::Robot.get_name(user_agent)
    
    user_agent = "Slurp/2.0"
    assert_equal "Inktomi", Sitealizer::Parser::Robot.get_name(user_agent)
    
    user_agent = "Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp )"
    assert_equal "Yahoo Slurp", Sitealizer::Parser::Robot.get_name(user_agent)
  end
  
  def test_language_get_name
    [["en","English"],["pt-pt","Portuguese"],["en-nz","English/New Zealand"],["es-mx","Spanish/Mexico",],
     ["ru-ru","Russian"],["de-at","German/Austria"],["fr-fr","French/France"],["zh-cn","Chinese/China"]].each do |l|
      assert_equal l[1], Sitealizer::Parser::Language.get_name(l[0])
    end
  end
  
end
