require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'

PKG_VERSION = "5.0.2"
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
     /\.log$/, /^pkg/, /\.svn/, /^vendor\/rails\/(?!actionwebservice)/, 
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
  
  s.add_dependency("rails", ">= 2.0.2")
  s.add_dependency("mongrel", ">= 1.1.3")
  s.add_dependency("mongrel_cluster", ">= 0.2.0")
  s.add_dependency("sqlite3-ruby", ">= 1.1.0")
  s.add_dependency("rails-app-installer", ">= 0.2.0")
  s.add_dependency("xmpp4r", ">= 0.3.1")
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

desc "Publish the zip/tgz"
task :leetsoft_upload => [:package] do
  Rake::SshFilePublisher.new("leetsoft.com", "dist/pkg", "pkg", "#{PKG_FILE_NAME}.zip").upload
  Rake::SshFilePublisher.new("leetsoft.com", "dist/pkg", "pkg", "#{PKG_FILE_NAME}.tgz").upload
end

desc "Publish the release files to RubyForge."
task :tag_svn do
  system("svn cp svn://typosphere.org/typo/trunk svn://typosphere.org/typo/tags/release_#{PKG_VERSION.gsub(/\./,'_')} -m 'tag release #{PKG_VERSION}'")
end

desc "Publish the release files to RubyForge."
task :rubyforge_upload => [:package] do
  files = ["tgz", "zip"].map { |ext| "pkg/#{PKG_FILE_NAME}.#{ext}" }

  if RUBY_FORGE_PROJECT then
    require 'net/http'
    require 'open-uri'

    project_uri = "http://rubyforge.org/projects/#{RUBY_FORGE_PROJECT}/"
    project_data = open(project_uri) { |data| data.read }
    group_id = project_data[/[?&]group_id=(\d+)/, 1]
    raise "Couldn't get group id" unless group_id

    # This echos password to shell which is a bit sucky
    if ENV["RUBY_FORGE_PASSWORD"]
      password = ENV["RUBY_FORGE_PASSWORD"]
    else
      print "#{RUBY_FORGE_USER}@rubyforge.org's password: "
      password = STDIN.gets.chomp
    end

    login_response = Net::HTTP.start("rubyforge.org", 80) do |http|
      data = [
        "login=1",
        "form_loginname=#{RUBY_FORGE_USER}",
        "form_pw=#{password}"
      ].join("&")
      http.post("/account/login.php", data)
    end

    cookie = login_response["set-cookie"]
    raise "Login failed" unless cookie
    headers = { "Cookie" => cookie }

    release_uri = "http://rubyforge.org/frs/admin/?group_id=#{group_id}"
    release_data = open(release_uri, headers) { |data| data.read }
    package_id = release_data[/[?&]package_id=(\d+)/, 1]
    raise "Couldn't get package id" unless package_id

    first_file = true
    release_id = ""

    files.each do |filename|
      basename  = File.basename(filename)
      file_ext  = File.extname(filename)
      file_data = File.open(filename, "rb") { |file| file.read }

      puts "Releasing #{basename}..."

      release_response = Net::HTTP.start("rubyforge.org", 80) do |http|
        release_date = Time.now.strftime("%Y-%m-%d %H:%M")
        type_map = {
          ".zip"    => "3000",
          ".tgz"    => "3110",
          ".gz"     => "3110",
          ".gem"    => "1400"
        }; type_map.default = "9999"
        type = type_map[file_ext]
        boundary = "rubyqMY6QN9bp6e4kS21H4y0zxcvoor"

        query_hash = if first_file then
          {
            "group_id" => group_id,
            "package_id" => package_id,
            "release_name" => RELEASE_NAME,
            "release_date" => release_date,
            "type_id" => type,
            "processor_id" => "8000", # Any
            "release_notes" => "",
            "release_changes" => "",
            "preformatted" => "1",
            "submit" => "1"
          }
        else
          {
            "group_id" => group_id,
            "release_id" => release_id,
            "package_id" => package_id,
            "step2" => "1",
            "type_id" => type,
            "processor_id" => "8000", # Any
            "submit" => "Add This File"
          }
        end

        query = "?" + query_hash.map do |(name, value)|
          [name, URI.encode(value)].join("=")
        end.join("&")

        data = [
          "--" + boundary,
          "Content-Disposition: form-data; name=\"userfile\"; filename=\"#{basename}\"",
          "Content-Type: application/octet-stream",
          "Content-Transfer-Encoding: binary",
          "", file_data, ""
          ].join("\x0D\x0A")

        release_headers = headers.merge(
          "Content-Type" => "multipart/form-data; boundary=#{boundary}"
        )

        target = first_file ? "/frs/admin/qrs.php" : "/frs/admin/editrelease.php"
        http.post(target + query, data, release_headers)
      end

      if first_file then
        release_id = release_response.body[/release_id=(\d+)/, 1]
        raise("Couldn't get release id") unless release_id
      end

      first_file = false
    end
  end
end

desc "Upload the package to leetsoft, rubyforge and tag the release in svn"
#task :release => [:sweep_cache, :package, :leetsoft_upload, :rubyforge_upload, :tag_svn ]
task :release => [:sweep_cache, :package ]
