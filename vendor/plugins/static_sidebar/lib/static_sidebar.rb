class StaticSidebar < Sidebar
  DEFAULT_TEXT = %q{
<ul>
  <li><a href="http://www.typosphere.org" title="Typo">Typosphere</a></li>
  <li><a href="http://typogarden.org">Typogarden</a></li>
  <li><a href="http://www.bofh.org.uk" title="Just a Summary">Just A Summary</a></li>
  <li><a href="http://fredericdevillamil.com" title="Frédéric de Villamil">Ergonomie, Rails et Architecture de l'information web</a></li>
  <li><a href="/admin">Admin</a></li>
</ul>
}
  description "Static content, like links to other sites, advertisements, or blog meta-information"

  setting :title, 'Links'
  setting :body,  DEFAULT_TEXT, :input_type => :text_area

end
