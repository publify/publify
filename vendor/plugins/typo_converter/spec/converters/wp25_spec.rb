require File.dirname(__FILE__) + '/../spec_helper'

# These are integration tests.

describe "WordPress 2.5 converter" do
  before :each do
    Factory('WP25/option',
      :option_name => 'blogname', :option_value => 'My WordPress Blog')
    Factory('WP25/option',
      :option_name => 'blogdescription', :option_value => 'WordPress blog description')
  end
  
  it "runs without crashing" do
    run_converter
  end
  
  describe "given a user" do
    it "creates a user"
  end
  
  describe "given a post" do
    it "creates an article"
    
    describe "with a comment" do
      it "creates a comment"
      
      describe "that is spam" do
        it "marks the created comment as spam"
      end
    end
    
    describe "that is a page" do
      it "creates a page"
    end
  end
  
  describe "given tags and categories" do
    it "behaves in a manner to be determined"
  end
  
protected
  
  def run_converter(options = {})
    real_stdout = $stdout
    begin
      $stdout = StringIO.new unless options[:verbose]
      TypoPlugins.convert_from :wp25
    ensure
      $stdout = real_stdout
    end
  end
end
