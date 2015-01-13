# coding: utf-8
require 'rubygems/package_task'

PKG_VERSION = '6.9.0'
PKG_NAME = 'publify'
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"
RUBY_FORGE_PROJECT = 'publify'
RUBY_FORGE_USER = 'fdevillamil'
RELEASE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"

spec = Gem::Specification.new do |s|
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.summary = 'Modern weblog engine.'
  s.has_rdoc = false

  s.files = Dir.glob('**/*', File::FNM_DOTMATCH).reject do |f|
    [/\.$/, /config\/database.yml$/, /config\/database.yml-/,
     /database\.sqlite/,
     /\.log$/, /^pkg/, /\.git/, /Gemfile\.lock/, /^vendor\/rails/,
     /^public\/(files|xml|articles|pages|index.html)/,
     /^public\/(stylesheets|javascripts|images)\/theme/, /\~$/,
     /\/\._/, /\/#/].any? { |regex| f =~ regex }
  end
  s.require_path = '.'
  s.author = 'Frédéric de Villamil'
  s.email = 'frederic@de-villamil.com'
  s.homepage = 'http://publify.co'
  s.rubyforge_project = 'publify'
  s.platform = Gem::Platform::RUBY
end

Gem::PackageTask.new(spec) do |p|
  p.need_tar = true
  p.need_zip = true
end

task release: [:sweep_cache, :package]
