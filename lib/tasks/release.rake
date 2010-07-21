require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'

PKG_VERSION = "5.5"
PKG_NAME = "typo"
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"
RUBY_FORGE_PROJECT = 'typo'
RUBY_FORGE_USER = 'fdevillamil'
RELEASE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"

spec = Gem::Specification.new do |s|
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.summary = "Modern weblog engine."
  s.has_rdoc = false
  
  s.files = Dir.glob('**/*', File::FNM_DOTMATCH).reject do |f| 
     [ /\.$/, /config\/database.yml$/, /config\/database.yml-/, 
     /database\.sqlite/,
     /\.log$/, /^pkg/, /\.git/, /^vendor\/rails/, 
     /^public\/(files|xml|articles|pages|index.html)/, 
     /^public\/(stylesheets|javascripts|images)\/theme/, /\~$/, 
     /\/\._/, /\/#/ ].any? {|regex| f =~ regex }
  end
  s.require_path = '.'
  s.author = "Frédéric de Villamil"
  s.email = "frederic@de-villamil.com"
  s.homepage = "http://typosphere.org"  
  s.rubyforge_project = "typo"
  s.platform = Gem::Platform::RUBY 
  s.executables = ['typo']
  
  s.add_dependency("rails", "= 2.3.8")
  s.add_dependency("rails-app-installer", ">= 0.2.0")
  s.add_dependency("ruby-debug", ">= 0.10.3")
  s.add_dependency("flexmock", ">= 0.8.3")
  s.add_dependency("rspec-rails", "= 1.3.2")
  s.add_dependency("bluecloth", "~> 2.0.5")
  s.add_dependency("htmlentities")
  s.add_dependency("json")
  s.add_dependency("calendar_date_select")
  s.add_dependency("coderay", "~> 0.9")
  s.add_dependency('RedCloth', "~> 4.2.2")
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

desc "Upload the package to leetsoft, rubyforge and tag the release in svn"
task :release => [:sweep_cache, :package ]
