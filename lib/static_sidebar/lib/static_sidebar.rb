# coding: utf-8
class StaticSidebar < Sidebar
  DEFAULT_TEXT = %q{
<ul>
  <li><a href="http://www.typosphere.org" title="Typo">Typosphere</a></li>
  <li><a href="http://t37.net" title="Le Rayon UX">Frédéric</a></li>
  <li><a href="http://www.matijs.net/" title="Matijs">Matijs</a></li>
  <li><a href="http://elsif.fr" title="Yannick">Yannick</a></li>
  <li><a href="http://blog.ookook.fr" title="Thomas">Thomas</a></li>
  <li><a href="/admin">Admin</a></li>
</ul>
}
  description "Static content, like links to other sites, advertisements, or blog meta-information"

  setting :title, 'Links'
  setting :body,  DEFAULT_TEXT, :input_type => :text_area

end
