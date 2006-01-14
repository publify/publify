class Plugins::Sidebars::StaticController < Sidebars::Plugin
  def self.display_name
    "Static"
  end

  def self.description
    "Static content, like links to other sites, advertisements, or blog meta-infomation"
  end

  def self.default_config
    {'title'=>'Links',
     'body'=>%q{<ul>
  <li><a href="http://typo.leetsoft.com" title="Typo">Typo</a></li>
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
}}
  end
  
  def configure
  end
end
