class Plugins::Sidebars::StaticController < Sidebars::ComponentPlugin
  description "Static content, like links to other sites, advertisements, or blog meta-infomation"


  DEFAULT_TEXT = %q{
<ul>
  <li><a href="http://www.typosphere.org" title="Typo">Typo</a></li>
  <li><a href="http://blog.leetsoft.com" title="too-biased">too-biased</a></li>
  <li><a href="http://www.poocs.net/" title="poocs.net">poocs.net</a></li>
  <li><a href="http://blog.remor.com/" title="seth hall">Seth Hall</a></li>
  <li><a href="http://encytemedia.com" title="Encyte Media">EncyteMedia</a></li>
  <li><a href="http://scottstuff.net" title="Scottstuff">scottstuff.net</a></li>
  <li><a href="http://www.bofh.org.uk" title="Just a Summary">Just A Summary</a></li>
  <li><a href="http://nubyonrails.com" title="Topfunky">Topfunky</a></li>
  <li><a href="http://planettypo.com" title="PlanetTypo">PlanetTypo</a></li>
  <li><a href="http://typoforums.org" title="Typo Forums">Typo Forums</a></li>
</ul>
}

  setting :title, 'Links'
  setting :body, DEFAULT_TEXT, :input_type => :text_area

end
