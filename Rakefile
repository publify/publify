require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'

PKG_VERSION = "2.5.5"
PKG_NAME = "typo"
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"
RUBY_FORGE_PROJECT = 'typo'
RUBY_FORGE_USER = 'xal'
RELEASE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"

$VERBOSE = nil
TEST_CHANGES_SINCE = Time.now - 600

desc "Run all the tests on a fresh test database"
task :default => [ :test_units, :test_functional ]


desc 'Require application environment.'
task :environment do
  unless defined? RAILS_ROOT
    require File.dirname(__FILE__) + '/config/environment'
  end
end

desc "Generate API documentation, show coding stats"
task :doc => [ :appdoc, :stats ]


# Look up tests for recently modified sources.
def recent_tests(source_pattern, test_path, touched_since = 10.minutes.ago)
  FileList[source_pattern].map do |path|
    if File.mtime(path) > touched_since
      test = "#{test_path}/#{File.basename(path, '.rb')}_test.rb"
      test if File.exists?(test)
    end
  end.compact
end

desc 'Test recent changes.'
Rake::TestTask.new(:recent => [ :clone_structure_to_test ]) do |t|
  since = TEST_CHANGES_SINCE
  touched = FileList['test/**/*_test.rb'].select { |path| File.mtime(path) > since } +
    recent_tests('app/models/*.rb', 'test/unit', since) +
    recent_tests('app/controllers/*.rb', 'test/functional', since)

  t.libs << 'test'
  t.verbose = false
  t.test_files = touched.uniq
end
task :test_recent => [ :clone_structure_to_test ]

desc "Run the unit tests in test/unit"
Rake::TestTask.new("test_units") { |t|
  t.libs << "test"
  t.pattern = 'test/unit/**/*_test.rb'
  t.verbose = false
}
task :test_units => [ :clone_structure_to_test ]

desc "Run the functional tests in test/functional"
Rake::TestTask.new("test_functional") { |t|
  t.libs << "test"
  t.pattern = 'test/functional/**/*_test.rb'
  t.verbose = false
}
task :test_functional => [ :clone_structure_to_test ]

desc "Generate documentation for the application"
Rake::RDocTask.new("appdoc") { |rdoc|
  rdoc.rdoc_dir = 'doc/app'
  rdoc.title    = "Rails Application Documentation"
  rdoc.options << '--line-numbers --inline-source'
  rdoc.rdoc_files.include('doc/README_FOR_APP')
  rdoc.rdoc_files.include('app/**/*.rb')
}

desc "Generate documentation for the Rails framework"
Rake::RDocTask.new("apidoc") { |rdoc|
  rdoc.rdoc_dir = 'doc/api'
  rdoc.template = "#{ENV['template']}.rb" if ENV['template']
  rdoc.title    = "Rails Framework Documentation"
  rdoc.options << '--line-numbers --inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('CHANGELOG')
  rdoc.rdoc_files.include('vendor/rails/railties/CHANGELOG')
  rdoc.rdoc_files.include('vendor/rails/railties/MIT-LICENSE')
  rdoc.rdoc_files.include('vendor/rails/activerecord/README')
  rdoc.rdoc_files.include('vendor/rails/activerecord/CHANGELOG')
  rdoc.rdoc_files.include('vendor/rails/activerecord/lib/active_record/**/*.rb')
  rdoc.rdoc_files.exclude('vendor/rails/activerecord/lib/active_record/vendor/*')
  rdoc.rdoc_files.include('vendor/rails/actionpack/README')
  rdoc.rdoc_files.include('vendor/rails/actionpack/CHANGELOG')
  rdoc.rdoc_files.include('vendor/rails/actionpack/lib/action_controller/**/*.rb')
  rdoc.rdoc_files.include('vendor/rails/actionpack/lib/action_view/**/*.rb')
  rdoc.rdoc_files.include('vendor/rails/actionmailer/README')
  rdoc.rdoc_files.include('vendor/rails/actionmailer/CHANGELOG')
  rdoc.rdoc_files.include('vendor/rails/actionmailer/lib/action_mailer/base.rb')
  rdoc.rdoc_files.include('vendor/rails/actionwebservice/README')
  rdoc.rdoc_files.include('vendor/rails/actionwebservice/CHANGELOG')
  rdoc.rdoc_files.include('vendor/rails/actionwebservice/lib/action_web_service.rb')
  rdoc.rdoc_files.include('vendor/rails/actionwebservice/lib/action_web_service/*.rb')
  rdoc.rdoc_files.include('vendor/rails/actionwebservice/lib/action_web_service/api/*.rb')
  rdoc.rdoc_files.include('vendor/rails/actionwebservice/lib/action_web_service/client/*.rb')
  rdoc.rdoc_files.include('vendor/rails/actionwebservice/lib/action_web_service/container/*.rb')
  rdoc.rdoc_files.include('vendor/rails/actionwebservice/lib/action_web_service/dispatcher/*.rb')
  rdoc.rdoc_files.include('vendor/rails/actionwebservice/lib/action_web_service/protocol/*.rb')
  rdoc.rdoc_files.include('vendor/rails/actionwebservice/lib/action_web_service/support/*.rb')
  rdoc.rdoc_files.include('vendor/rails/activesupport/README')
  rdoc.rdoc_files.include('vendor/rails/activesupport/CHANGELOG')
  rdoc.rdoc_files.include('vendor/rails/activesupport/lib/active_support/**/*.rb')
}

desc "Report code statistics (KLOCs, etc) from the application"
task :stats => [ :environment ] do
  require 'code_statistics'
  CodeStatistics.new(
    ["Helpers", "app/helpers"], 
    ["Controllers", "app/controllers"], 
    ["APIs", "app/apis"],
    ["Components", "components"],
    ["Functionals", "test/functional"],
    ["Models", "app/models"],
    ["Units", "test/unit"]
  ).to_s
end

desc "Recreate the test databases from the development structure"
task :clone_structure_to_test => [ :db_structure_dump, :purge_test_database ] do
  abcs = ActiveRecord::Base.configurations
  case abcs["test"]["adapter"]
    when  "mysql"
      ActiveRecord::Base.establish_connection(:test)
      ActiveRecord::Base.connection.execute('SET foreign_key_checks = 0')
      IO.readlines("db/#{RAILS_ENV}_structure.sql").join.split("\n\n").each do |table|
        ActiveRecord::Base.connection.execute(table)
      end
    when "postgresql"
      ENV['PGHOST']     = abcs["test"]["host"] if abcs["test"]["host"]
      ENV['PGPORT']     = abcs["test"]["port"].to_s if abcs["test"]["port"]
      ENV['PGPASSWORD'] = abcs["test"]["password"]
      `psql -U "#{abcs["test"]["username"]}" -f db/#{RAILS_ENV}_structure.sql #{abcs["test"]["database"]}`
    when "sqlite", "sqlite3"
      `#{abcs[RAILS_ENV]["adapter"]} #{abcs["test"]["dbfile"]} < db/#{RAILS_ENV}_structure.sql`
    else 
      raise "Unknown database adapter '#{abcs["test"]["adapter"]}'"
  end
end

desc "Dump the database structure to a SQL file"
task :db_structure_dump => :environment do
  abcs = ActiveRecord::Base.configurations
  case abcs[RAILS_ENV]["adapter"] 
    when "mysql"
      ActiveRecord::Base.establish_connection(abcs[RAILS_ENV])
      File.open("db/#{RAILS_ENV}_structure.sql", "w+") { |f| f << ActiveRecord::Base.connection.structure_dump }
    when "postgresql"
      ENV['PGHOST']     = abcs[RAILS_ENV]["host"] if abcs[RAILS_ENV]["host"]
      ENV['PGPORT']     = abcs[RAILS_ENV]["port"].to_s if abcs[RAILS_ENV]["port"]
      ENV['PGPASSWORD'] = abcs[RAILS_ENV]["password"]
      `pg_dump -U "#{abcs[RAILS_ENV]["username"]}" -s -x -f db/#{RAILS_ENV}_structure.sql #{abcs[RAILS_ENV]["database"]}`
    when "sqlite", "sqlite3"
      `#{abcs[RAILS_ENV]["adapter"]} #{abcs[RAILS_ENV]["dbfile"]} .schema > db/#{RAILS_ENV}_structure.sql`
    else 
      raise "Unknown database adapter '#{abcs["test"]["adapter"]}'"
  end
end

desc "Empty the test database"
task :purge_test_database => :environment do
  abcs = ActiveRecord::Base.configurations
  case abcs["test"]["adapter"]
    when "mysql"
      ActiveRecord::Base.establish_connection(abcs[RAILS_ENV])
      ActiveRecord::Base.connection.recreate_database(abcs["test"]["database"])
    when "postgresql"
      ENV['PGHOST']     = abcs["test"]["host"] if abcs["test"]["host"]
      ENV['PGPORT']     = abcs["test"]["port"].to_s if abcs["test"]["port"]
      ENV['PGPASSWORD'] = abcs["test"]["password"]
      `dropdb -U "#{abcs["test"]["username"]}" #{abcs["test"]["database"]}`
      `createdb -T template0 -U "#{abcs["test"]["username"]}" #{abcs["test"]["database"]}`
    when "sqlite","sqlite3"
      File.delete(abcs["test"]["dbfile"]) if File.exist?(abcs["test"]["dbfile"])
    else 
      raise "Unknown database adapter '#{abcs["test"]["adapter"]}'"
  end
end


spec = Gem::Specification.new do |s|
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.summary = "Modern weblog engine."
  s.has_rdoc = false
  s.files  = Dir.glob('**/*', File::FNM_DOTMATCH).reject do |f| 
     [ /\.$/, /sqlite$/, /\.log$/, /^pkg/, /\.svn/, /^vendor\/rails/, 
     /^public\/(files|xml|articles|pages|index.html)/, 
     /^public\/(stylesheets|javascripts|images)\/theme/, /\~$/, 
     /\/\._/, /\/#/ ].any? {|regex| f =~ regex }
  end
  s.require_path = '.'
  s.author = "Tobias Luetke"
  s.email = "tobi@leetsoft.com"
  s.homepage = "http://typo.leetsoft.com"  
  s.rubyforge_project = "typo"
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

desc "Migrate the database according to the migrate scripts in db/migrate (only supported on PG/MySQL). A specific version can be targetted with VERSION=x"
task :migrate => :environment do
  ActiveRecord::Migrator.migrate(File.dirname(__FILE__) + '/db/migrate/', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
end

desc "Create new db/schema files using the migrations.  Requires schema_generator."
task :schemas do
  `./script/generate --force schema`
  `sed s/InnoDB/MyISAM/ < db/schema.mysql.sql > db/schema.mysql-v3.sql`
end

desc "Force a sweeping run of typo's static page caches (all of them!)"
task :sweep_cache => :environment do
  PageCache.sweep_all
  puts "Cache swept."
end

desc "Publish the zip/tgz"
task :leetsoft_upload => [:package] do
  Rake::SshFilePublisher.new("leetsoft.com", "dist/pkg", "pkg", "#{PKG_FILE_NAME}.zip").upload
  Rake::SshFilePublisher.new("leetsoft.com", "dist/pkg", "pkg", "#{PKG_FILE_NAME}.tgz").upload
end

desc "Publish the release files to RubyForge."
task :tag_svn do
  system("svn cp svn://leetsoft.com/typo/trunk svn://leetsoft.com/typo/tags/release_#{PKG_VERSION.gsub(/\./,'_')} -m 'tag release #{PKG_VERSION}'")
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
task :release => [:sweep_cache, :package, :leetsoft_upload, :rubyforge_upload, :tag_svn ]
