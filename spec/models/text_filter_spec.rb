require File.dirname(__FILE__) + '/../spec_helper'

context "With the list of available filters" do
  setup { @filters = TextFilter.available_filters }

  specify 'Markdown is an available filter' do
    @filters.should_include Typo::Textfilter::Markdown
  end

  specify 'Smartypants is available' do
    @filters.should_include Typo::Textfilter::Smartypants
  end

  specify 'Htmlfilter is available' do
    @filters.should_include Typo::Textfilter::Htmlfilter
  end

  specify 'Textile is available' do
    @filters.should_include Typo::Textfilter::Textile
  end

  specify 'Amazon is available' do
    @filters.should_include Typo::Textfilter::Amazon
  end

  specify 'Flickr is available' do
    @filters.should_include Typo::Textfilter::Flickr
  end

  specify 'TextFilterPlugin::Markup should be unavailable' do
    @filters.should_not_include TextFilterPlugin::Markup
  end

  specify 'TextFilterPlugin::Macro should be unavailable' do
    @filters.should_not_include TextFilterPlugin::Macro
  end

end
