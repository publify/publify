Dir[File.dirname(__FILE__)+'/*_test.rb'].each do |test|
  require test
end