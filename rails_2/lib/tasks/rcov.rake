rspec_base = File.expand_path(File.join(RAILS_ROOT,'vendor/plugins/rspec/lib'))
$LOAD_PATH.unshift(rspec_base) if File.exist?(rspec_base)
require 'rcov/rcovtask'
require 'spec/rake/spectask'
require 'spec/translator'
namespace 'rcov' do
  task :setup do
    rm_f "coverage"
    rm_f "coverage.data"
  end
  namespace 'unit' do
    Rcov::RcovTask.new do |t|
      t.name = "test"
      t.libs << "test"
      t.test_files = FileList['test/unit/**/*test.rb']   
      t.verbose = true
      t.rcov_opts = ['-x', '^lib,^config/boot', '--rails', '--sort', 'coverage', '--aggregate', 'coverage.data']     
    end
  end
  namespace 'functional' do
    Rcov::RcovTask.new do |t|
      t.name = "test"
      t.libs << "test"
      t.test_files = FileList['test/functional/**/*test.rb']   
      t.verbose = true
      t.rcov_opts = ['-x', '^lib,^config/boot', '--rails', '--sort', 'coverage', '--aggregate', 'coverage.data']     
    end
  end
  desc "Run all specs in spec directory with RCov (excluding plugin specs)"
  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec', '--rails', '--sort', 'coverage', '--aggregate', 'coverage.data']
  end
  desc "Rcov over all different test types"
  task :all => [:setup, 'unit:test', 'functional:test', :spec] 
end
