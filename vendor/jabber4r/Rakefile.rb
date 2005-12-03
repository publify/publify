$:.unshift('lib')
require 'rubygems'
begin
  require 'xforge'
rescue LoadError
  puts "**** Warning. XForge not installed. Release tasks won't work ****"
end
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'

PKG_NAME = "jabber4r"

PKG_VERSION = "0.8.0"
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"
PKG_FILES = FileList[
  '[A-Z]*',
  'lib/**/*.rb'
]

task :default => [:gem]

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['**/*test*.rb']
  t.verbose = true
end

# Create a task to build the RDOC documentation tree.
rd = Rake::RDocTask.new("rdoc") do |rdoc|
  rdoc.rdoc_dir = 'html'
  rdoc.title    = "Jabber4r"
  rdoc.options << '--line-numbers' << '--inline-source' << '--main' << 'README'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# ====================================================================
# Create a task that will package the Rake software into distributable
# tar, zip and gem files.

spec = Gem::Specification.new do |s|

  #### Basic information.

  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.summary = "Jabber4r is a pure-Ruby Jabber client library"
  s.description = <<-EOF
    The purpose of this library is to allow Ruby applications to 
    talk to a Jabber IM system. Jabber is an open-source instant 
    messaging service, which can be learned about at http://www.jabber.org
  EOF

  s.files = PKG_FILES.to_a
  s.require_path = 'lib'

  #### Documentation and testing.

  s.has_rdoc = true
  s.extra_rdoc_files = rd.rdoc_files.reject { |fn| fn =~ /\.rb$/ }.to_a
  s.rdoc_options <<
    '--title' <<  'Jabber4r' <<
    '--main' << 'README' <<
    '--line-numbers'

  #### Author and project details.

  s.author = "Richard Kilmer"
  s.email = "rich@infoether.com"
  s.rubyforge_project = "jabber4r"
  s.homepage = "http://jabber4r.rubyforge.org"
end

desc "Build Gem"
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end
task :gem => [:test]

# Support Tasks ------------------------------------------------------

def egrep(pattern)
  Dir['**/*.rb'].each do |fn|
    count = 0
    open(fn) do |f|
      while line = f.gets
        count += 1
        if line =~ pattern
          puts "#{fn}:#{count}:#{line}"
        end
      end
    end
  end
end

desc "Look for TODO and FIXME tags in the code"
task :todo do
  egrep /#.*(FIXME|TODO|TBD)/
end

task :release => [:verify_env_vars, :release_files, :publish_doc, :publish_news]

task :verify_env_vars do
  raise "RUBYFORGE_USER environment variable not set!" unless ENV['RUBYFORGE_USER']
  raise "RUBYFORGE_PASSWORD environment variable not set!" unless ENV['RUBYFORGE_PASSWORD']
end

task :publish_doc => [:rdoc] do
  publisher = Rake::RubyForgePublisher.new(PKG_NAME, ENV['RUBYFORGE_USER'])
  publisher.upload
end

desc "Release gem to RubyForge. MAKE SURE PKG_VERSION is aligned with the CHANGELOG file"
task :release_files => [:gem] do
  release_files = FileList[
    "pkg/#{PKG_FILE_NAME}.gem"
  ]

  Rake::XForge::Release.new(PKG_NAME) do |xf|
    # Never hardcode user name and password in the Rakefile!
    xf.user_name = ENV['RUBYFORGE_USER']
    xf.password = ENV['RUBYFORGE_PASSWORD']
    xf.files = release_files.to_a
    xf.release_name = "Jabber4r #{PKG_VERSION}"
  end
end

desc "Publish news on RubyForge"
task :publish_news => [:gem] do
  release_files = FileList[
    "pkg/#{PKG_FILE_NAME}.gem"
  ]

  Rake::XForge::NewsPublisher.new(PKG_NAME) do |news|
    # Never hardcode user name and password in the Rakefile!
    news.user_name = ENV['RUBYFORGE_USER']
    news.password = ENV['RUBYFORGE_PASSWORD']
  end
end
