# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "typo"
  s.version     = "6.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Frédéric de Villamil", "Matijs van Zuijlen", "Yannick François", "Thomas Lecavellier", "Cyril Mougel"]
  s.email       = ["frederic@de-villamil.com"]
  s.homepage    = "http://typosphere.org"
  s.summary     = %q{The missing blogging engine.}
  s.description = %q{Since Typo has been in existence since March 2005, it is likely the oldest blogging platform in Rails. It has a full set of features you would expect from such an engine, which include powerful SEO capabilities, full themes, and plug-in extensions. }
  s.has_rdoc    = false
  s.rubyforge_project = "typo"

  s.files         = `ls`.split("\n")
  s.post_install_message = "\e[1;31m\n" + ('-' * 79) + "\n\n" + File.read('PostInstall.txt') + "\n" + ('-' * 79) + "\n\e[0m"
end