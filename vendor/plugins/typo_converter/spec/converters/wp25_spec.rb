require File.dirname(__FILE__) + '/../spec_helper'

describe "WordPress 2.5 converter" do
  before :each do
    Factory('WP25/option',
      :option_name => 'blogname', :option_value => 'My WordPress Blog')
    Factory('WP25/option',
      :option_name => 'blogdescription', :option_value => 'WordPress blog description')
  end
  
  it "runs without crashing" do
    TypoPlugins.convert_from :wp25
  end
end
