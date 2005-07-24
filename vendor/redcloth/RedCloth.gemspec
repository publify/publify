require 'rubygems'
spec = Gem::Specification.new do |s|

  ## Basic Information

  s.name = 'RedCloth'
  s.version = "3.0.3"
  s.platform = Gem::Platform::RUBY
  s.summary = <<-TXT
    RedCloth is a module for using Textile and Markdown in Ruby. Textile and Markdown are text formats. 
    A very simple text format. Another stab at making readable text that can be converted to HTML.
  TXT
  s.description = <<-TXT
    No need to use verbose HTML to build your docs, your blogs, your pages.  Textile gives you readable text while you're writing and beautiful text for your readers.  And if you need to break out into HTML, Textile will allow you to do so.

    Textile also handles some subtleties of formatting which will enhance your document's readability:

    * Single- and double-quotes around words or phrases are converted to curly quotations, much easier on
      the eye.  "Observe!"

    * Double hyphens are replaced with an em-dash.  Observe -- very nice!

    * Single hyphens are replaced with en-dashes. Observe - so cute!

    * Triplets of periods become an ellipsis.  Observe...

    * The letter 'x' becomes a dimension sign when used alone.  Observe: 2 x 2.

    * Conversion of ==(TM)== to (TM), ==(R)== to (R), ==(C)== to (C).

    For more on Textile's language, hop over to "A Textile Reference":http://hobix.com/textile/.  For more
    on Markdown, see "Daring Fireball's page":http://daringfireball.net/projects/markdown/.
  TXT

  ## Include tests, libs, docs

  s.files = ['bin/**/*', 'tests/**/*', 'lib/**/*', 'docs/**/*', 'run-tests.rb'].collect do |dirglob|
                Dir.glob(dirglob)
            end.flatten.delete_if {|item| item.include?("CVS")}

  ## Load-time details

  s.require_path = 'lib'
  s.autorequire = 'redcloth'

  ## Author and project details

  s.author = "Why the Lucky Stiff"
  s.email = "why@ruby-lang.org"
  s.rubyforge_project = "redcloth"
  s.homepage = "http://www.whytheluckystiff.net/ruby/redcloth/"
end
