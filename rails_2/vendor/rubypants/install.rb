# Install RubyPants.

require "rbconfig"
require "fileutils"

source = "rubypants.rb"
dest = File.join(Config::CONFIG["sitelibdir"], source)

FileUtils.install(source, dest, :mode => 0644, :verbose => true)
