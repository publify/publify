namespace :typo_converter do
  namespace :schema do
    namespace :load do
      desc 'Load the WordPress 2.5 converter schema into the wp25 database'
      task :wp25 => :environment do
        # TODO: use a separate test database
        config = ActiveRecord::Base.configurations['wp25']
        ActiveRecord::Base.establish_connection config
        file = "#{File.dirname(__FILE__)}/../db/wp25_schema.rb"
        load(file)
      end
    end
  end
end
          
# TODO: run converter
