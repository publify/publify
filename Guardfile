group :red_green_refactor, halt_on_fail: true do
  guard :bundler do
    watch('Gemfile')
  end

  guard 'livereload' do
    watch(%r{app/views/.+\.(erb|haml|slim)$})
    watch(%r{app/helpers/.+\.rb})
    watch(/public\/.+\.(css|js|html)/)
    watch(%r{config/locales/.+\.yml})
    watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|png|jpg))).*}) { |m| "/assets/#{m[3]}" }
  end

  guard 'rails', cmd: 'spring rails' do
    watch('Gemfile.lock')
    watch(/^(config|lib)\/.*/)
  end

  guard :rspec, cmd: 'spring rspec', all_on_start: false do
    watch(/^spec\/.+_spec\.rb$/)
    watch(/^lib\/(.+)\.rb$/)     { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { 'spec' }
    watch(/^app\/(.+)\.rb$/)                           { |m| "spec/#{m[1]}_spec.rb" }
    watch(/^app\/(.*)(\.erb|\.haml|\.slim)$/)          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  do |m|
      [
        "spec/routing/#{m[1]}_routing_spec.rb",
        "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
        "spec/acceptance/#{m[1]}_spec.rb"
      ]
    end
    watch(%r{^spec/support/(.+)\.rb$})                  { 'spec' }
    watch('config/routes.rb')                           { 'spec/routing' }
    watch('app/controllers/application_controller.rb')  { 'spec/controllers' }
    watch('spec/rails_helper.rb')                       { 'spec' }
  end

  guard :rubocop, all_on_start: false do
    watch(/.+\.rb$/)
    watch(/(?:.+\/)?\.rubocop\.yml$/) { |m| File.dirname(m[0]) }
  end
end
